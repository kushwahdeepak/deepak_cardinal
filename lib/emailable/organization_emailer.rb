module OrganizationEmailer
  ENDPOINT = '/api/v1/outgoing_mail'
  TYPE = 'email_user_inviting_to_organization'

  def self.send_approval_email(owner_email: '', name: '')
    subject = 'Your Organization is approved'
    content = OutgoingEmailsHelper.employer_allow_job_post(name)

    res = HttpClient.post(
      url: HttpClient.url(ENDPOINT), 
      multipart: true, 
      body: self.email_params(email: owner_email, subject: subject, content: content, type: TYPE), 
      headers: HttpClient.headers
    )
    puts res
  end

  def self.send_pending_email(owner_email: '', content: '', type: '')
    subject = 'Your Organization is pending'

    res = HttpClient.post(
      url: HttpClient.url(ENDPOINT), 
      multipart: true, 
      body: self.email_params(email: owner_email, subject: subject, content: content, type: TYPE), 
      headers: HttpClient.headers
    )
  end

  def self.send_rejected_email(owner_email: '', content: '', type: '')
    subject = 'Your Organization is rejected'
    type = 'email_user_inviting_to_organization'
    endpoint = '/api/v1/outgoing_mail'

    res = HttpClient.post(
      url: HttpClient.url(endpoint), 
      multipart: true, 
      body: self.email_params(email: owner_email, subject: subject, content: content, type: type), 
      headers: HttpClient.headers
    )
  end

  private

  def self.email_params(email: '', subject: '', content: '', type: '')
    {
      recipient_email: email,
      sender_email: HttpClient::OUTGOING_MAIL_USERNAME,
      subject: subject,
      content: content,
      email_type: type
    }
  end

end
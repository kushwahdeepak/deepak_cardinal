module UserEmailer
  def self.send_account_verified_email(reciptent_email: '', name: '')
    subject = 'Your account is confirmed'
    type = 'email_user_inviting_to_organization'
    endpoint = '/api/v1/outgoing_mail'
    content = OutgoingEmailsHelper.email_verify_success(name)

    res = HttpClient.post(
      url: HttpClient.url(endpoint), 
      multipart: true, 
      body: self.email_params(email: reciptent_email, subject: subject, content: content, type: type), 
      headers: HttpClient.headers
    )
  end

  def self.notify_employer_job_posting_status(reciptent_email: '', name: '')
    subject = 'Your account is ready to post jobs'
    type = 'email_user_inviting_to_organization'
    endpoint = '/api/v1/outgoing_mail'
    content = OutgoingEmailsHelper.employer_allowed_to_post_job(name)

    res = HttpClient.post(
      url: HttpClient.url(endpoint), 
      multipart: true, 
      body: self.email_params(email: reciptent_email, subject: subject, content: content, type: type), 
      headers: HttpClient.headers
    )
  end

  def self.notify_employer_job_posting_pending_status(reciptent_email: '', name: '')
    subject = 'Your account ready to post jobs'
    type = 'email_user_inviting_to_organization'
    endpoint = '/api/v1/outgoing_mail'
    content = OutgoingEmailsHelper.employer_pending_to_job_post(name)

    res = HttpClient.post(
      url: HttpClient.url(endpoint), 
      multipart: true, 
      body: self.email_params(email: reciptent_email, subject: subject, content: content, type: type), 
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
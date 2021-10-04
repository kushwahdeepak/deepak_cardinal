module JobEmailer
  ENDPOINT = '/api/v1/outgoing_mail'
  Type = 'email_user_inviting_to_organization'

  def self.send_approved_email(owner_email: '', content: '')
    subject = 'Your Job is posted and live'

    res = HttpClient.post(
      url: HttpClient.url(ENDPOINT), 
      multipart: true, 
      body: self.email_params(email: owner_email, subject: subject, content: content, type: Type), 
      headers: HttpClient.headers
    )
  end

  def self.send_pending_email(owner_email: '', content: '')
    subject = 'Your Job status is pending'

    res = HttpClient.post(
      url: HttpClient.url(ENDPOINT), 
      multipart: true, 
      body: self.email_params(email: owner_email, subject: subject, content: content, type: Type), 
      headers: HttpClient.headers
    )
  end

  def self.send_email_to_user_for_newly_add_candidate_for_job(email: '', content: '')
    subject = 'New Candidate Added'
    endpoint = '/api/v1/outgoing_mail'

    res = HttpClient.post(
      url: HttpClient.url(ENDPOINT),
      multipart: true,
      body: self.email_params(email: email, subject: subject, content: content, type: Type),
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
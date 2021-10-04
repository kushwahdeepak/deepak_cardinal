class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    user = User.find_by_email(@email.from[:email])
    message = user.posts.create(
      subject: @email.subject,
      body: @email.body,
      to: @email.to,
      from: @email.from,
      raw_text: @email.raw_text,
      raw_body: @email.raw_body,
      attachments: @email.attachments,
      headers: @email.headers,
      raw_headers: @email.raw_headers
    )
    conversation = message.conversation
  end
end

class CustomMessageMailer < Mailboxer::BaseMailer
  def send_email(message, receiver)
    if message.conversation.messages.size > 1
      reply_message_email(message,receiver)
    else
      new_message_email(message,receiver)
    end
  end

  def new_message_email(message,receiver)
    @message  = message
    @receiver = receiver
    set_subject(message)
    mail :to => receiver.send(Mailboxer.email_method, message),
         :subject => t('mailboxer.message_mailer.subject_new', :subject => @subject),
         :template_name => 'new_message_email'
  end

  def reply_message_email(message,receiver)
    @message  = message
    @receiver = receiver
    set_subject(message)
    mail :to => receiver.send(Mailboxer.email_method, message),
         :subject => t('mailboxer.message_mailer.subject_reply', :subject => @subject),
         :template_name => 'reply_message_email'
  end
end

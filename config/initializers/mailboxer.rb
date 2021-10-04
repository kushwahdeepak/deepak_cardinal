Mailboxer.setup do |config|

  #Configures if your application uses or not email sending for Notifications and Messages
  config.uses_emails = false

  #Configures the default from for emails sent for Messages and Notifications
  config.default_from = 'contact@cardinalhire.com'

  #Configures the methods needed by mailboxer
  config.email_method = :mailboxer_email
  config.name_method = :mailboxer_name
  config.notify_method = :notify

  #Configures if you use or not a search engine and which one you are using
  #Supported engines: [:solr,:sphinx,:pg_search]
  config.search_enabled = false
  config.search_engine = :pg_search

  #Configures maximum length of the message subject and body
  config.subject_max_length = 255
  config.body_max_length = 32000

  #Configure a new CustomMessageMailer that uses GMail API
  config.message_mailer = CustomMessageMailer
end

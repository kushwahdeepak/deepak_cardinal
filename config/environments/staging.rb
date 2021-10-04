require 'mail'


Rails.application.configure do
  config.active_storage.service = :amazon
  config.public_file_server.enabled = true
  # config.force_ssl = true
  config.cache_classes = true
  config.eager_load = false
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=31536000'
  }
  config.assets.css_compressor = :sass
  config.assets.js_compressor = Uglifier.new(harmony: true)
  # config.action_controller.asset_host = ENV.fetch('ASSET_HOST')
  config.assets.digest = true
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.active_job.queue_adapter     = :sidekiq
  config.i18n.fallbacks = [I18n.default_locale]
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV.fetch('RAILS_LOG_TO_STDOUT')
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.enable_dependency_loading = true
  #Dont add constant host name
  config.action_controller.asset_host = ENV['HOST']
  config.action_mailer.asset_host = config.action_controller.asset_host

  config.action_mailer.delivery_method = :smtp
  host = ENV['HOST']
  config.action_mailer.default_url_options = {host: host}
   # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
   :address              => "smtp.gmail.com",
   :port                 => 587,
   :user_name            => ENV.fetch('OUTGOING_EMAIL_USERNAME'),
   :password             => ENV.fetch('OUTGOING_EMAIL_PASSWORD'),
   :authentication       => "plain",
   :enable_starttls_auto => true
   }

  config.action_cable.url = ENV['WEBSOCKETS_URL']
  config.action_cable.allowed_request_origins = [ENV['CABLE_REQ_ORIGINS']]
  #config.action_cable.allowed_request_origins = ['https://www.cardinaltalent.ai', 'www.cardinaltalent.ai', 'https://ch-job-marketplace-prod.herokuapp.com']

end

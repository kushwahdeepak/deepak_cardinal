Sentry.init do |config|
  # config.dsn = 'https://036a5c49d0c544db8df1b0526f96eaa3@o897214.ingest.sentry.io/5841497'
  config.dsn = 'https://bac9d273a3dd48a39ec1a1d8eb59d0c1@o918272.ingest.sentry.io/5861281'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 1.0
  config.enabled_environments = %w[production]

  config.async = lambda do |event, hint|
    Sentry::SendEventJob.perform_later(event, hint)
  end

  # config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']

  config.send_default_pii = true

end

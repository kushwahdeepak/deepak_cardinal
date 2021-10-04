Rails.application.configure do
  config.active_storage.service = :amazon

  # config.log_formatter = ::Logger::Formatter.new
  # #if ENV.fetch('RAILS_LOG_TO_STDOUT') #todo what env is read for tests?
  # logger           = ActiveSupport::Logger.new(STDOUT)
  # logger.formatter = config.log_formatter
  # config.logger = ActiveSupport::TaggedLogging.new(logger)
  # #end


  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # # Enable/disable caching. By default caching is disabled.
  # if Rails.root.join('tmp/caching-dev.txt').exist?
  #   config.action_controller.perform_caching = false
  #
  #   config.cache_store = :memory_store
  #   config.public_file_server.headers = {
  #     'Cache-Control' => 'public, max-age=172800'
  #   }
  # else
  #   config.action_controller.perform_caching = false
  #
  #   config.cache_store = :null_store
  # end

  # Don't care if the mailer can't send.

  config.action_controller.asset_host = 'http://localhost:3000'
  config.action_mailer.asset_host = config.action_controller.asset_host



  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = false

  config.assets.raise_runtime_errors = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker



  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter     = :sidekiq


  config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg *.ico *.eot *.ttf)

  require 'mail'

  Mail.defaults do
    delivery_method :smtp, {
      :address => 'localhost',
      :port => '1025',
      :domain => 'localhost'
    }
  end

  config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg *.ico *.eot *.ttf)
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { :host => 'localhost:3000', protocol: 'http' }
  config.action_mailer.smtp_settings = { address: '127.0.0.1', port: 1025 }
  config.action_cable.url = ENV['WEBSOCKETS_URL']

  class ActiveRecord::Base
    def dump_fixture
      fixture_file = "#{Rails.root}/spec/fixtures/#{self.class.table_name}.yml"
      File.open(fixture_file, "a+") do |f|
        f.puts({ "#{self.class.table_name.singularize}_#{id}" => attributes }.
            to_yaml.sub!(/---\s?/, "\n"))
      end
    end
  end
end

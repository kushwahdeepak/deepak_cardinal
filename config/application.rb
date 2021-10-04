require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "active_storage/engine"
require 'dotenv/load'


# require "rails/test_unit/railtie"
require 'csv'

Bundler.require(*Rails.groups)
class Authorization
  def self.incoming_mails_view?(user, record) user.admin? || user.recruiter? || (user.employer? && record.user == user) end
  def self.people_search?(user)  user.admin? || user.recruiter? || user.employer? end
  def self.people_intake?(user) user.admin? || user.recruiter? || user.employer? end
  def self.jobs_view?(user) user.admin? || user.recruiter? || user.employer? || user.talent? end
  def self.notes_view?(user)  user.admin? || user.recruiter? end
  def self.jobs_create?(user) user.admin? || user.recruiter? || user.employer? end
  def self.job_update?(user, record) user.admin? || record.user == user end
  def self.admin?(user) user.admin? end
  def self.referrals_create?(user) user.recruiter? || user.talent? || user.employer? end
end

module CardinalTalent
  class Application < Rails::Application

    Dotenv.require_keys(
      "DATABASE_URL",
      "GOOGLE_CLIENT_ID",
      "GOOGLE_CLIENT_SECRET",
    )

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching = false
    config.action_mailer.smtp_settings = {
      address:              'smtp.sendgrid.net',
      port:                 587,
      domain:               'example.com',
      user_name:            'apikey',
      password:             ENV['SENDGRID_API_KEY'],
      authentication:       'plain',
      enable_starttls_auto: true }

    config.assets.quiet = true
    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    
    config.autoload_paths += Dir[ Rails.root.join("lib", '**/',) ]

    config.generators do |g|
      g.factory_bot false
    end
    config.active_record.schema_format = :sql
    config.time_zone = 'Pacific Time (US & Canada)'

    # Remove this line to let ActiveRecord Time zone aware columns take
    # precedence (Strings will be parsed as if they were 'Time.zone')
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.log_formatter = ::Logger::Formatter.new
    # if ENV.fetch('RAILS_LOG_TO_STDOUT')
    #   logger           = ActiveSupport::Logger.new(STDOUT)
    #   logger.formatter = config.log_formatter
    #   config.logger = ActiveSupport::TaggedLogging.new(logger)
    # end
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    Rails.application.routes.default_url_options[:host] = ENV['HOST']

  end
end

# Be sure to restart your server when you modify this file.
require 'sidekiq/web'
Rails.application.config.session_store :cookie_store, key: '_CardinalTalent_session'
# Rails.application.config.session_store :active_record_store, key: '_devise-omniauth_session'
Sidekiq::Web.disable(:sessions)



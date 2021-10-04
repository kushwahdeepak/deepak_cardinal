require 'google/api_client/client_secrets.rb'
require 'google/apis/gmail_v1'

class TargetedMessagesMailer < ApplicationMailer
  def targeted_message_email(message, user)
    @message = message
    mail = Mail.new(to: @message.to,
      subject: @message.subject,
      body: @message.body,
      from: @message.from,
      reply_to: @message.from)
    gmail_message = Google::Apis::GmailV1::Message.new(
      raw: mail.to_s
    )

    strategy = OmniAuth::Strategies::GoogleOauth2.new(nil, ENV.fetch('GOOGLE_CLIENT_ID'), ENV.fetch('GOOGLE_CLIENT_SECRET'))
    client = strategy.client
    token = OAuth2::AccessToken.new client, user.google_token, {refresh_token: user.google_refresh_token}

    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = google_secret(user).to_authorization
    service.authorization.refresh!

    begin
      service.send_user_message(
        user.email,
        gmail_message
      )
    rescue Google::Apis::AuthorizationError => exception
      client.refresh!
      retry
    rescue Exception => exception
      raise exception
    end
  end

  private

  def google_secret(user)
    @user = User.find(user)
    Google::APIClient::ClientSecrets.new(
      { "web" =>
        { "access_token" => @user.google_token,
          "refresh_token" => @user.google_refresh_token,
          "client_id" => ENV.fetch('GOOGLE_CLIENT_ID'),
          "client_secret" => ENV.fetch('GOOGLE_CLIENT_SECRET'),
        }
      }
    )
  end
end

require 'aws-sdk-ses'

module Aws
  class Aws::EmailFailed < StandardError; end

  class EmailClient
    SENDER_EMAIL = 'amit@vertivert.com'

    def self.send_verification_email(to: '')
      begin
        client = aws_ses_client()
        client.verify_email_identity({email_address: to})
      rescue Aws::SES::Errors::ServiceError => error
        raise Aws::EmailFailed, 'Failed to send verification mail'
      end
    end


    def self.aws_ses_client
      Aws::SES::Client.new(
        region: ENV['SES_REGION'],
        access_key_id: ENV['SES_ACCESS_KEY'], 
        secret_access_key: ENV['SES_SECRET_KEY']
       )
    end
    private_class_method :aws_ses_client
  end
end
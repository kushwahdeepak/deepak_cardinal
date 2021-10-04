class OutgoingMailService
  require 'httparty'

  def self.retrieve_email_credentials email_address
    url = "#{self.base_url}/api/v1/email_credentials/find_email_credentials?email_address=#{email_address}"
    result = HTTParty.get(url, :headers => self.headers)
    rescue HTTParty::Error => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
  end

  def self.send_email_params outgoing_mail_params
    email_credentials = outgoing_mail_params.delete(:email_credentials)
    if email_credentials.present?
      organization_id = outgoing_mail_params.delete(:organization_id)
      email_address = OutgoingMailService.retrieve_email_credentials(email_credentials[:email_address]).payload.parsed_response["email_address"]
      unless email_address.present?
        response = OutgoingMailService.send_email_credential(email_credentials, organization_id)
        return OpenStruct.new({success?: false, error: response.payload["errors"]}) unless response && response.payload["errors"].blank?
      end
    end
    
    url = "#{self.base_url}/api/v1/outgoing_mail"
    result = HTTParty.post(url, :multipart => true, :body => outgoing_mail_params, :headers => self.headers)
    rescue HTTParty::Error => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
  end

  def self.send_email_credential email_credential_params, organisation_id
    params = email_credential_params.as_json
    params["organisation_id"] = organisation_id
    url = "#{self.base_url}/api/v1/email_credentials"
    result = HTTParty.post(url, :body => { email_credential: params }.to_json, :headers => self.headers)
    rescue HTTParty::Error => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
  end

  def self.update_email_credential email_credential_params, email_credential_id
    url = "#{self.base_url}/api/v1/email_credentials/#{email_credential_id}"
    result = HTTParty.put(url, :body => email_credential_params.to_json, :headers => self.headers)
    rescue HTTParty::Error => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
  end

  private

  def self.base_url
    ENV.fetch("OUTGOING_MAIL_API_URL")
  end

  def self.headers
    {
      'Content-Type' => 'multipart/form-data',
      'Authorization' => self.outgoing_mail_key
    }
  end

  def self.outgoing_mail_key
    ENV.fetch("OUTGOING_MAIL_SERVICE_KEY")
  end
end

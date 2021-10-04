require 'httparty'

module HttpClient
  BASE_URL = ENV.fetch('OUTGOING_MAIL_API_URL')
  OUTGOING_MAIL_SECRET_KEY = ENV.fetch('OUTGOING_MAIL_SERVICE_KEY')
  OUTGOING_MAIL_USERNAME   = ENV.fetch('OUTGOING_EMAIL_USERNAME')

  def self.get(url: '', format: '', headers: {})
    return if url.blank?
    HTTParty.get(url)
  end

  def self.post(url: '', multipart: false, body: '',headers: {})
    result = HTTParty.post(url, :multipart => multipart, :body => body, :headers => headers)
    rescue HTTParty::Error => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
  end

  private

  def self.url(endpoint)
    if Rails.env.development?
      return 'https://qa.inoutemailservice.com' + endpoint
    end
    BASE_URL + endpoint
  end

  def self.outgoing_mail_secret_key
    if Rails.env.development?
      return 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MDMyNTg4OTR9.ZtAkno438Guz6Wxu0cRkylBnur_bYvqC3hZoFaTEcUY'
    end
    ENV.fetch('OUTGOING_MAIL_SERVICE_KEY')
  end

  def self.headers
    {
      'Content-Type' => 'multipart/form-data',
      'Authorization' => self.outgoing_mail_secret_key
    }
  end
end
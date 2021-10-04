##
# Incoming mail processing works like this.
# * A candidate applies to one of our jobs in linkedin.
# * Confirmation email is sent to our email account (tobuforefront@gmail.com).
# * From there, it is forwarded to Cloudmailin's email (5142611706c9ed915a34@cloudmailin.net) using gmail fileters mechanism.
# * Cloudmailin converts the email to HTTP post to /incoming_mails.
# * In the /incoming_mails/new handler, the email email plain content and resume are processed into a new IncomingMail
# instance, Submission and, if person with email address doesn't exist, a new Person.
# * If person (aka candidate) is deterined to be top 20 percent, email s

class IncomingMail < ApplicationRecord
  include IncomingMailsHelper

  # Associations
  has_one_attached :attachment
  has_one :submission

  # Enum
  enum source: ['linkedin', 'indeed']

  # Scopes
  scope :today, -> {where("created_at >= ?", Time.zone.now.beginning_of_day)}

  def parsed_mail= hash
    self.parsed_mail_json = hash.to_json
  end

  def parsed_mail
    (parsed_mail_json.present?) ? (ActiveSupport::JSON.decode parsed_mail_json) : ({})
  end
  
end

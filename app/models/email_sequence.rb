class EmailSequence < ApplicationRecord
  self.skip_time_zone_conversion_for_attributes = [:sent_at]

  before_save do
    self.sent_at = DateTime.parse(sent_at.to_s).utc
  end

  EMAIL_1 = 'email1'.freeze
  EMAIL_2 = 'email2'.freeze
  EMAIL_3 = 'email3'.freeze
  enum sequence: {
    email1: EMAIL_1,
    email2: EMAIL_2,
    email3: EMAIL_3
  }
  belongs_to :job
  validates :subject, presence: true
  validates :email_body, presence: true
  validates_presence_of :sent_at, presence: true
  validates :sequence, presence: true
end

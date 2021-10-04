class Campaign < ApplicationRecord
  has_many :campaign_recipients, dependent: :destroy
  has_many :recipients, through: :campaign_recipients, foreign_key: :recipient_id
  belongs_to :user

  validates :source_address, :content, :subject, :user_id, :job_id,
              presence: true
  validates :source_address, format: { with: URI::MailTo::EMAIL_REGEXP }
end

#TODO: change contact_recipient_at on recipient_was_contacted_at in find_contacted_recipients when
#functionality will be implemented

class CampaignRecipient < ApplicationRecord
  enum status: { sent: "sent", pending: "pending", failed: "failed" }

  validates :recipient_id, :campaign_id, :contact_recipient_at, presence: true

  belongs_to :campaign
  belongs_to :organization
  belongs_to :recipient, class_name: 'Person', foreign_key: :recipient_id

  class << self
    def find_contacted_recipients(organization_id, period_key)
      where(
        contact_recipient_at: period(period_key)..DateTime.current.end_of_day,
        organization_id: organization_id
      )
    end

    private

    def period(period_key)
      case period_key
      when 'week'
        DateTime.current.beginning_of_day - 1.week
      when 'month'
        DateTime.current.beginning_of_day - 1.month
      when 'year'
        DateTime.current.beginning_of_day - 1.year
      end
    end
  end
end

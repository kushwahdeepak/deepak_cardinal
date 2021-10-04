# == Schema Information
#
# Table name: lever_payload_subscriptions
#
#  id             :integer          not null, primary key
#  user_id :integer
#  webhook_token  :string
#  subscribed     :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module LeverPayload
  class Subscription < LeverPayload::Base
    belongs_to :user, class_name: 'User'

    validates :user_id, presence: true, uniqueness: true
    validates_presence_of :webhook_token

    scope :subscribed, -> { where(subscribed: true) }

    before_validation(on: :create) do
      generate_webhook_token
    end

    private

    # Generate simple random salt
    def random_salt(len = 20)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      salt = ''
      1.upto(len) { |i| salt << chars[rand(chars.size-1)] }
      salt
    end

    # SHA1 with user_id, random salt and time
    def generate_webhook_token
      webhook_token = nil
      loop do
        webhook_token = Digest::SHA1.hexdigest("#{user_id}#{random_salt}#{Time.now.to_i}")
        if LeverPayload::Subscription.where(webhook_token: webhook_token).first.blank?
          break
        end
      end
      self.webhook_token = webhook_token
    end
  end
end

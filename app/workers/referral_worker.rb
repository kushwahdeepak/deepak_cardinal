class ReferralWorker
  include Sidekiq::Worker

  def perform(referral_id)
    ReferralMailer.invitation(referral_id).deliver
  end

end

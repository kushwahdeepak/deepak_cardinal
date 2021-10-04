class ReferralMailer < ApplicationMailer

  def invitation(referral_id)
    @referral = Referral.find_by(id: referral_id)

    @job = @referral.job
    @user = @referral.user
    @url = "#{ENV['HOST']}/jobs/#{@job.try(:id)}?token=#{@referral.invitee_code}"

    @referral.update(email_send_date: Time.now)

    mail to: @referral.invitee_email, subject: "Invited for applying new job"

  end

end

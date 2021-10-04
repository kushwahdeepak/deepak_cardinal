class ReferralsController < ApplicationController
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  def create
    referrals_params[:referrals]&.each do |referral_data|
      # user = User.find_by(email: referral_data[:invitee_email])
      # next if user.present?

      attr = {
        inviter_id: current_user.id,
        job_id: params[:job_id],
        invitation_date: Time.now,
        invitee_name: referral_data[:invitee_name],
        invitee_email: referral_data[:invitee_email],
        message: params[:message]
      }

      referral = Referral.new(attr)
      authorize referral

      if referral.save
        referral.invitation(referral.id)
      end
    end

    render json: {status: 'success', message: "Invited successfully"}
  end

  private

  def referrals_params
    params.permit(referrals: [:invitee_name, :invitee_email])
  end

end

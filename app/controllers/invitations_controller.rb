class InvitationsController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :set_user, only: %i[create]
  before_action :set_organization

  respond_to :html, :json

  def new
    @invitation = Invitation.new
    without_user_ids = Invitation.where(organization_id: @organization.id, inviting_user_id: current_user.id).pluck(:invited_user_id).push(current_user.id)
    @users = User.where.not(id: without_user_ids).where.not(name: [nil, ""])
  end

  def create
    Invitation.where(organization_id: @organization.id, inviting_user_id: current_user.id, invited_user_id: invitation_params[:invited_user_id]).update_all(status: 'rejected')
    invited_user = User.find_by(id: invitation_params[:invited_user_id])
    invitation = Invitation.new(invitation_params)
    invitation.organization = @organization
    invitation.inviting_user = current_user
    invitation.status = Invitation::PENDING
    if invitation.save
      invitation.send_email_to_invite
      render json: {type: 'success', message: 'invitation sent successfully',invited_recruiter_details: invited_user}, status: 200
    else
      flash[:error] = invitation.errors.messages
      redirect_back(fallback_location: organization_path(@organization))
    end
  end

  private

  def set_organization
    @organization ||= Organization.find(params[:organization_id])
  end

  def invitation_params
    params.require(:invitation).permit(:invited_user_id)
  end
end

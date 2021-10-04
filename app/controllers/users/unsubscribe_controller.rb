class Users::UnsubscribeController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :set_user, only: [:show]

  def create
    if Unsubscribe.create!(unsubscribe_params)
      return render json: {message: 'Unsubscribed successfully'}, status: 200
    end
      return render json: {message: 'Ops, not able to unsubscribe'}, status: 401
  end

  # GET: /users/unsubscribe/:user_id
  def show; end

  # API
  # TODO: /unsubscribe/optout/reasons
  def optout_reasons
    render json: {data: Unsubscribe::OPT_OUT_REASONS}
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def unsubscribe_params
    params.require(:unsubscribe).permit(
      :email,
      :reason
    )
  end
end
  
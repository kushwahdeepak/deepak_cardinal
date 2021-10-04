class Users::EmailVerificationController < ApplicationController
  before_action :set_user, only: [:send_verification_email]
  rescue_from ActiveRecord::RecordNotFound, with: :render_error
  rescue_from StandardError, with: :render_error

  # POST: /account/email_verification
  def send_verification_email
    begin
      Aws::EmailClient.send_verification_email(to: @user.email)
    rescue Aws::EmailFailed
      raise StandardError, 'amazon aws ses failed to send verification link'
    end
    render json: {msg: "Verification email send"}, status: 200 and return
  end

  # GET: /account/email_verification/success
  def success; end

  # GET: /account/email_verification/failure
  def failure; end

  private

  def set_user
    @user = User.find_by!(email: email_verification_params[:email])
  end

  def email_verification_params
    params.require(:email_verification).permit(:email)
  end

  def render_error
    render json: {msg: 'Not able to send verification email'}, status: 200 and return
  end
end

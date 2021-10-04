class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  def new; end

  def create
    UserRegistrationService.new(registration_params: registration_params, organization_params: organization_params, organization_logo: organization_logo_params).call
  end
  
  def resend_confirmation
    begin
      user = User.find_by(email: params[:user][:email])
      content = OutgoingEmailsHelper.email_confirmation user
      subject = 'Please confirm your email'
      params = {
        recipient_email: user.email,
        sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
        subject: subject,
        content: content,
        email_type: "email_confirmation"
      }
      OutgoingMailService.send_email_params(params)
      return render json: {msg: "Confirmation Email Send Successfully"},status: 200
    rescue Exception => e
      return render json: {msg: "Something wrong, plese try again"},status: 422
    end
  end
  
  private

  def registration_params
    user_params.merge(person_params)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :industry, :company_size, :country,:city,:region,:website_url)
  end

  def organization_logo_params
    params.require(:organization).permit(:logo)
  end

  def person_params
    params.require(:registration).permit(
      :first_name,
      :last_name,
      :zipcode,
      :phone_number,
      :location,
      :state,
      :address,
      :resume,
      :linkedin_profile_url,
      :title,
      :active_job_seeker
    )
  end
end

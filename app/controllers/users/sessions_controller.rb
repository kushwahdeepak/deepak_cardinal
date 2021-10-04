class Users::SessionsController < Devise::SessionsController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :html, :js

  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    raise Pundit::NotAuthorizedError unless resource and resource.user_approved?

    if resource.valid_password?(params[:user][:password])
      if resource.email_confirmed?
        sign_in :user, resource
        return render json: {
          user: resource.id,
          email: resource.email,
          first_name: resource.first_name,
          last_name: resource.last_name,
          role:resource.role,
          sync_job:resource.sync_job,
          organization_id:resource.organization_id
        }
      else
        sign_out
        return invalid_login_attempt :unconfirmed
      end
    end

    invalid_login_attempt
  end

  protected

  def invalid_login_attempt(message_type = :invalid)
    set_flash_message(:alert, message_type)
    render json: flash.to_hash, status: 401
  end

  def user_not_authorized(message_type = :invalid)
    flash[:alert] = "You are not authorised to login, please contact administrator"
    render json: flash.to_hash, status: 401
  end

end
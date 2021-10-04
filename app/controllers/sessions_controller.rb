class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
   super
  end

  def destroy
   super
  end

  def after_sign_in_path_for(resource)
    if resource.sign_in_count <= 1
      if resource.signuprole == 'talent'
        welcome_new_talent_path
      elsif resource.signuprole == 'employer'
        welcome_new_employer_path
      elsif resource.signuprole == 'recruiter'
        welcome_new_recruiter_path
      else
        user_dashboard_path(current_user)
      end
    else
      user_dashboard_path(current_user)
    end
  end

  def googleAuth
    # Get access tokens from Google
    access_token = request.env["omniauth.auth"]
    user = User.from_omniauth(access_token)
    log_in(user)

    # Use access_token to authenticate request made from app to google
    user.google_token = access_token.credentials.token

    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    user.google_refresh_token = refresh_token if refresh_token.present?
    user.save!

    redirect_to root_path
  end
end

class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env['omniauth.auth'], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to after_signup_path(:step_one)
        end
      end
    }
  end

  [:facebook, :github, :gplus, :linkedin, :twitter].each do |provider|
    provides_callback_for provider
  end

  def linkedin
    @user = User.find_for_oauth(env['omniauth.auth'], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LinkedIn".capitalize) if is_navigational_format?
    else
      session["devise.linkedin_data"] = ENV["omniauth.auth"]
      redirect_to after_signup_path(:step_one)
    end
  end

  def google_oauth2
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    # Get access tokens from Google
    access_token = request.env["omniauth.auth"]

    if @user.role == 'guest'
      page = request.env['omniauth.params']['page']
      if page == '/welcome/employer'
        @user.role = 'employer'
      else
        @user.role = 'talent'
      end
    end

    # Use access_token to authenticate request made from app to google
    # @user.google_token = access_token.credentials.token

    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request!
    refresh_token = access_token.credentials.refresh_token
    @user.google_refresh_token = refresh_token if refresh_token.present?
    @user.save!

    if @user.persisted?
      # flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def after_sign_in_path_for(resource)
    if session[:contact_request_id].present?
      invite_my_connection_path(id: session[:contact_request_id])

    # Update signup date into referrals table based on referral token
    elsif session[:referral_token].present?
      @referral = Referral.find_by(invitee_code: session[:referral_token])
      failure and return if @referral.blank?

      update_referral_signup
      job_path(id: @referral.job_id)

    elsif resource.email_verified?
      after_signup_path(:step_one)
      page = request.env['omniauth.params']['page']

      if resource.talent?
        talent_home_path

      elsif resource.employer?
          employer_home_path

      elsif page.nil? || page == '/welcome/employer' || page == '/'
        return '/'
      else
        page
      end
    else
      after_signup_path(:step_one)
    end
  end

  def failure
    redirect_to root_path
  end

  def update_referral_signup
    @referral.update(signup_date: Time.now)
  end

end

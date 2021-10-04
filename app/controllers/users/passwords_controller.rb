class Users::PasswordsController < Devise::PasswordsController
  respond_to :js

  after_action :check_user_confrimation, only: [:edit]

  def check_user_confrimation
    user = resource_class.find_by(email: params[:email])
    return unless user
    user.email_activate unless user.email_confirmed
  end  
end
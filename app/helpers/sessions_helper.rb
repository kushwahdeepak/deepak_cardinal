module SessionsHelper
  def create_session(user)
    session[:user_id] = user.id
  end

  def destroy_session(*)
    session[:user_id] = nil
  end
end

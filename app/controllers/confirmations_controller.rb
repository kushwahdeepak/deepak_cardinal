class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super
  end

  private

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    after_signup_path(:step_one)
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    after_signup_path(:step_one)
  end
end

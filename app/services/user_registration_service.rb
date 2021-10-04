class UserRegistrationService
  attr_reader :role, :organization_params, :registration_params, :user

  def initialize(registration_params:, organization_params:, organization_logo:)
    @registration_params = registration_params
    @organization_params = organization_params
    @organization_logo = organization_logo
  end

  def call
    create_user
  end

  private

  # TODO: Improvemnt
  # calling create_person exposing funtionlity
  # could be potential source of bug later as it breaking
  # SRP(single responsibitiy principal). Need much more than
  # wrapping logic into a service object . Need to define
  # domain and and based on that need to define its behaivour
  # but for now it will fix the issue .
  def create_user
    ActiveRecord::Base.transaction do
      begin
        @user = User.create!(registration_params.except(:resume))
        @user.create_person(registration_params[:resume])
        create_organization if user.employer?
        send_confirmation_email(user)
      rescue => error
        Rails.logger.debug "Failed to singup: #{error}"
        raise ActiveRecord::Rollback
        rescue ActiveRecord::Rollback
        render json: { error: 'Failed to singup' }, status: :bad_request
      end
    end
  end

  def create_organization
    organization = Organization.new(organization_params)
    begin
      logo = Organization.upload_image_to_s3(@organization_logo[:logo])
      organization.image_url = logo.public_url if logo&.public_url.present?
    rescue
      render json: {type: 'failure', message: 'Failed to create Orgainzation'}, status: 422
      return
    end 
    organization.file_name = @organization_logo[:logo].original_filename
    organization.owner = @user
    organization.status = Organization::PENDING
    @user.organization = organization
    organization.save
    @user.save
  end

  def send_confirmation_email(user)
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
  end
end

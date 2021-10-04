require 'aws-sdk-s3'

class OrganizationsController < ApplicationController
  RESULTS_PER_PAGE = 25
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :authenticate_user!, except: [:company_profile,:exists,:get_organization]
  before_action :set_organization, only: %i[show edit update destroy]
  before_action :recruiter_person, only: %i[search_recruiter]
  respond_to :html, :json
  before_action :invited_recruiter, only: %i[index]

  def index
    if current_user.organization.present?
      @organization = current_user.organization
      @members = @organization.users.map{ |x| x.inspect}
      organization_recruiters = @organization.recruiter_organizations.where(status: RecruiterOrganization::ACCEPTED)
      @members << organization_recruiters.map{ |recruiter| recruiter.user.inspect }
      @recruiter = @members.flatten.uniq
      user_avatar_url(@recruiter)
      @avatar_url = @organization.image_url
    end
  end

  def new
    @organization = Organization.new
    @title = 'Enter new organization details'
  end

  def edit
    @title = 'Edit organization details'
  end

  def exists
    organization = Organization.exists?(name: params[:name])
    render json: { organization_exists: organization }
  end
 
  def show; end


  def get_users_in_organization
    users = current_user.organization.users
    members = users.select('id, name')
    render json: { message: 'Success', member: members }, status: :ok
  end

  def update
    if @organization.update(organization_params)

      respond_to do |format|
        format.html do
          redirect_to organizations_path, notice: 'Organization successully updated!'
        end

        format.json do
          # render json: @organization
          render json: {type: 'success', message: 'Update successfully'}, status: 200
        end
      end
    else
      flash[:error] = @organization.errors.messages
      redirect_back(fallback_location: organizations_path)
    end
  end

  def create
    organization = Organization.new(organization_params)
    organization.owner = current_user
    organization.status = Organization::PENDING
    current_user.organization = organization
    if organization.save && current_user.save
      redirect_to organizations_path, notice: 'Organization successully created! You will receive an email once it is approved.'
    else
      flash[:error] = 'Organization Name already exists!'
      redirect_back(fallback_location: organizations_path)
    end
  end

  def user_avatar_url(members)
    members.each do |member|
      member[:image_url] = Person.avatar_url(member['email'])
    end
  end

  def search_recruiter
    organization = current_user.organization
    user = User.where('lower(email) = ?', params[:organization][:email].downcase).first
    if Invitation.where(invited_user_id: user&.id, status: 'pending', organization_id: organization&.id).present?
      render json: {recruiter_data: '',message: "Already invited this recruiter"}, status: 200
      return
    elsif RecruiterOrganization.where(organization_id: organization&.id, user_id: user&.id, status: "accepted").present?
      render json: {recruiter_data: '',message: "Already a member of this organization"}, status: 200
      return
    else
      recruiter = user&.inspect
      recruiter[:image_url] = @person&.avatar&.service_url  if @person&.avatar&.attached?
      if recruiter.present? && recruiter[:role] == 'recruiter'
        render json: {recruiter_data: recruiter, type: 'success'}, status: 200
        return
      end
     render json: {recruiter_data: '',message: "No recruiter found with email #{params[:organization][:email]}"}, status: 200
    end
  end

  def search_member
    members = if params[:member].empty?
      current_user.organization.users
    else
      current_user.organization.users.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ? ", "%#{params[:member].downcase}%", "%#{params[:member].downcase}%")
    end
    if members.any?
      members = members.map{ |x| x.attributes.slice('id', 'first_name', 'last_name', 'role', 'email')}
      user_avatar_url(members)
      render json: { member_data: members }, status: 200
    else
      render json: { member_data: '', message: "No Organization found with name #{params[:member]}" }, status: 200
    end
  end

  def update
    if @organization&.update(organization_params)
      if params[:organization][:logo].present?
        begin
          logo = Organization.upload_image_to_s3(params[:organization][:logo])
          @organization&.update(image_url: logo.public_url, file_name: params[:organization][:logo].original_filename) if logo&.public_url.present? && @organization.try(:file_name) != params[:organization][:logo].original_filename
        rescue
          render json: {type: 'failure', message: 'Failed to upload'}, status: 422
          return
        end
      end
      render json: {type: 'success', message: 'Updated successfully'}, status: 200
    else
      flash[:error] = @organization.errors.messages
      redirect_back(fallback_location: organizations_path)
    end
  end


  def remove_member_from_organization
    user = User.find_by(id: params[:organization][:member_id])
    if user.present?
      recruiter_organization = user.recruiter_organizations.where(user_id: params[:organization][:member_id] , organization_id: params[:organization][:organization_id])
      recruiter_organization.update(status: RecruiterOrganization::REMOVED)
      if user&.recruiter_organizations.present?
        user&.update(organization: user&.recruiter_organizations&.first&.organization)
      else
        user.update(organization_id: nil)
      end
      render json: {message: "Member #{user.first_name} has been successully removed"}
    else
      render json: {message: "Something went wrong plese try again"}
    end
  end

  def destroy
    if @organization.update(is_deleted: true)
      respond_to do |format|
        format.html do
          redirect_to organizations_path, notice: 'Organization successully destroyed!'
        end

        format.json do
          render json: { message: 'Success' }, status: :ok
        end
      end
    else
      flash[:error] = @organization.errors.messages
      redirect_back(fallback_location: organizations_path)
    end
  end

  def change_recruiter_organization
    user = User.find_by(id: params[:user_id])
    if user.present?
      user.organization_id = params[:organization_id]
      user.save!
      render json: {message: 'Organiation update successfully', organization: user.organization}
    else
      render json: {message: 'User not found'}
    end
  end

  def approve
   @organization = Organization.find(params[:id])
    if @organization.update(status: Organization::APPROVED)
      render json: { message: 'Success' }, status: :ok
    end
  end

  def reject
    @organization = Organization.find(params[:id])
    if @organization.update(status: Organization::DECLINED)
      render json: { message: 'Success' }, status: :ok
    end
  end

  def get_users_in_organization
    if current_user.organization
      users = current_user.organization.users
      members = users.select('id, first_name', 'last_name', 'email')
      render json: { message: 'Success', member: members }, status: :ok
    else
      render json: { message: 'Success', member: [] }, status: :ok
    end
  end
  
  def get_organization
    organizations = params[:search].present? ? Organization.select('id','name').search(params[:search]) : Organization.select('id','name')
    render json: { organizations: organizations}, status: :ok
  end

  def company_profile
    @is_employer  = current_user ? current_user.employer? : false
    @organization = Organization.find(params[:id])
    job_query = JobQuery.new
    job_query.organization_jobs(@organization.id)
    @jobs = job_query.execute
    # @avatar_url = @organization.logo.service_url if @organization.logo.attached?
    @avatar_url = @organization&.image_url
  end

  def pending
    @organizations = Organization.pending.search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
    total_pages = @organizations.total_pages

    respond_to do |format|
      format.json do
        render json: { organizations: @organizations.as_json(methods: :email), total_pages: total_pages }
      end
    end
  end


  def search_for_organization
    organizations = params[:search].present? ? Organization.search(params[:search]) : Organization.all
    total_pages = organizations.paginate(page: params[:page], per_page: RESULTS_PER_PAGE).total_pages
    render json: { organizations: organizations.as_json(methods: :email), total_pages: total_pages }, status: :ok
  end

  def invited_recruiter
    users = []
    invited_users = current_user&.organization&.invitations&.where(status: 'pending')
    users << invited_users&.map{ |invited_user| User.find(invited_user.invited_user_id)}
    @invited_recruiters = users.flatten.uniq
  end

  private

  def organization_params
    params
    .require(:organization)
    .permit(:name, :description, :industry, :min_size, :max_size, :country, :region, :city, :company_size, :location )
  end

  def recruiter_person
    @person = Person.find_by(email_address: params[:organization][:email])
  end

  def set_organization
    @organization ||=  Organization.find_by(id: params[:id])
    if @organization.present?
      begin
        authorize @organization
      rescue Pundit::NotAuthorizedError
        render json: {failure: 'Sorry, you are not authorized to update this organization.'}
        return
      end
    else
      render json: {message: 'invalid organization'}
      return
    end
  end
end

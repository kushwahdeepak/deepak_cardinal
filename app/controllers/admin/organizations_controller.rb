require 'aws-sdk-s3'

class Admin::OrganizationsController < Admin::AdminsController
    include Pundit
  
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  
    before_action :authenticate_user!, except: [:company_profile,:exists]
    before_action :set_organization, only: %i[show edit update destroy]
    respond_to :html, :json
  
    def index
      organization = Organization.search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: Organization::RESULTS_PER_PAGE)        
      metadata = Organization.metadata(total: organization.count, page: params[:page].to_i)
      render json: Admin::OrganizationBlueprint.render(organization, view: :datatable, root: :organizations, meta: metadata)
    end
    
    def get_organization
      organizations = params[:search].present? ? Organization.select('id','name').search(params[:search]) : Organization.select('id','name')
      render json: { organizations: organizations}, status: :ok
    end

    def organizations_management
        @page_title = 'Organizations Dashboard - CardinalTalent'
      end

    def edit
      @title = 'Edit organization details'
    end
  
    def exists
      organization = Organization.exists?(name: params[:name])
      render json: { organization_exists: organization }
    end
   
    def show
      @members = RecruiterOrganization.organization_members(@organization.id) || []
      @avatar_url = @organization.image_url
      @jobs = Organization.find(params[:id]).jobs
    end
  
    def update
      if @organization.update(organization_params)
        if params[:organization][:logo].present?
          credentials = Aws::Credentials.new(ENV['BUCKETEER_AWS_ACCESS_KEY_ID'], ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'])
          s3 = Aws::S3::Resource.new(region:'us-east-2', credentials: credentials)
          obj = s3.bucket('cardinaltalent-prod').object(params[:organization][:logo].original_filename)
          obj.put(body: params[:organization][:logo].tempfile, acl: 'public-read')
          @organization&.update(image_url: obj.public_url, file_name: params[:organization][:logo].original_filename) if obj&.public_url.present? && @organization.try(:file_name) != params[:organization][:logo].original_filename
        end

        # approve owner (user) account activated
        @organization.owner.email_activate unless @organization.owner.email_confirmed

        respond_to do |format|
          format.html do
            redirect_to organizations_path, notice: 'Organization successully updated!'
          end
  
          format.json do
            render json: @organization
          end
        end
      else
        flash[:error] = @organization.errors.messages
        redirect_back(fallback_location: organizations_path)
      end
    end
  
    def destroy
      if @organization.discard
        return render json: { message: 'Success' }, status: :ok
      end
      render json: {message: 'Unable to delete organization'}, status: 401
  end
    
   
    def user_avatar_url(members)
      members.each do |member|
        member[:image_url] = Person.avatar_url(member['email'])
      end
    end
  
    def approve
     @organization = Organization.find(params[:id])
      if @organization.update(status: Organization::APPROVED)
        # approve owner(user) email account
        @organization.owner.email_activate unless @organization.owner.email_confirmed
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
  
    def pending
      @organization = Organization.where(status: 'pending').search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: Organization::RESULTS_PER_PAGE)
      @organizations = @organization.map do |record|
        record.attributes.merge(
          'owner_first_name' => record.owner.first_name,
          'owner_last_name' => record.owner.last_name,
          'owner_email' => record.owner.email,
        )
      end
      total_pages = @organization.total_pages
      if(total_pages % Organization::RESULTS_PER_PAGE != 0)
        total_pages = total_pages + 1
      end
      current_counts =  Organization::RESULTS_PER_PAGE * (params[:page].to_i)
      if(total_pages === params[:page].to_i)
        current_counts =  @organization.count
      end
        respond_to do |format|
          format.json do
            render json: { organizations: @organizations.as_json(methods: :email), total_pages: total_pages, current_counts:current_counts }
         
        end
      end
    end
  
    private
  
    def organization_params
      params
      .require(:organization)
      .permit(:name, :description, :industry, :min_size, :max_size, :country, :region, :city, :company_size, :location, :status)
    end
  
    def set_organization
      @organization ||= authorize Organization.find_by(id: params[:id])
      raise ActiveRecord::RecordNotFound if @organization.nil?
    end
end
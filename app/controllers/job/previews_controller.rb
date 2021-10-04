class Job::PreviewsController < ApplicationController
    include Pundit
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_job, only: %i[show edit update destroy]
  
    # GET /job/preview
    def index; end
  
    # GET /job/preview/1
    def show
      @url = "#{ENV["HOST"]}/jobs/#{@job.try(:id)}"
      @organizationId = @job.organization_id
      @organization = @job.organization
      @job_location = @job.locations.first    
    end
  
    # GET /job/preview/new
    def new; end
  
    # GET /job/preview/1/edit
    def edit; end
  
    # POST /job/preview
    def create
    end
  
    # PATCH/PUT /job/preview/1
    def update
    end
  
    # DELETE /job/preview/1
    def destroy
    end

    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find_by!(id: params[:id]) 
    end
  end
  
class Admin::JobsController < ApplicationController
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :authenticate_user!, except: %i[index show guest_person_apply]
  before_action :set_job, only: %i[show edit update destroy update_expired]

  # GET: /admin/jobs
  def index
    @page_title = 'Jobs List - CardinalTalent'
    @obs = []
    respond_to do |format|
      format.html
      format.json do
        jobs = Job.active_only.joins(:organization).select('jobs.*, organizations.name AS organization_name,organizations.image_url AS organization_image').order(created_at: :desc).search_by(keyword: params[:query], param: params)
        jobs_total_count = jobs.count
        total_pages =  (jobs_total_count/Job::RESULTS_PER_PAGE)
        if(jobs_total_count % Job::RESULTS_PER_PAGE != 0)
          total_pages = total_pages + 1
        end
      
        current_counts =  Job::RESULTS_PER_PAGE * (params[:page].to_i)
        if(total_pages === params[:page].to_i)
          current_counts =  jobs_total_count
        end

        render json: { jobs: jobs.uniq, total_pages: total_pages, total_count: jobs_total_count,current_counts: current_counts}
      end
    end
  end

  def new
    @page_title = 'Jobs Create - CardinalTalent'
    @job = Job.new
    @organization = Organization.new
    @industry = Lookup.where(name: 'industry')
  end

  # GET /jobs/1/edit
  def edit 
    @page_title = 'Jobs Edit - CardinalTalent'
    @organization = @job.organization
    @industry = Lookup.where(name: 'industry') 
  end

   # POST /jobs
  def create
    @job = Job.new(job_params.merge({expiry_date: DateTime.now + 30.days, user: current_user}))
    if @job.save!
      EmployerDashboard.create(job_id: @job.id, organization_id: @job.organization_id)
      redirect_to admin_jobs_url, status: 301 and return
    end
    Rails.logger.info "+++++++Failed to create jobs ++++++++++++"
    Rails.logger.debug "Error: #{@job.errors.messages}"
    render json: {msg: 'Failed to create job', msgType: 'success'}, status: 200
  end


  # PATCH/PUT /jobs/1
  def update
    unless @job.update(job_params.merge({expiry_date: DateTime.now + 30.days}))
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @job.errors.full_messages }
      end
    else
      respond_to do |format|
        format.html { redirect_to @job, notice: 'Job was successfully updated.', status: 200  }
        format.json { render json: { job: @job } }
      end
    end
  end
  
   # DELETE /jobs/1
   def destroy
    if @job.discard
      render json: {job: @job.to_hash, msg: 'Job closed successfully '} and return
    end
    render json: {msg: 'please try again'}
  end

  # Extend Job expired date
  def update_expired
    @update = @job.expiry_date+15.day
    if  @job.update(job_params.merge({expiry_date: @update}))
      render json: {job: @job.to_hash, msg: 'Job update successfully '}
    else
      render json: {msg: 'please try again'}
    end
  end 

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
      @job = Job.find_by(id: params[:id])
      raise ActiveRecord::RecordNotFound if @job.nil?
  end

  # Only allow a trusted parameter "white list" through.
  def job_params
    params.require(:job).permit(
      :name,
      :location,
      :description,
      :skills,
      :nice_to_have_skills,
      :notificationemails,
      :referral_amount,
      :referral_candidate,
      :email_campaign_subject,
      :email_campaign_desc,
      :sms_campaign_desc,
      :keywords,
      :nice_to_have_keywords,
      :location_preference,
      :experience_years,
      :prefered_titles,
      :prefered_industries,
      :department,
      :status,
      :organization_id,
      :school_names,
      :company_names,
      :expiry_date,
      # :location_names,
      # :education_preference,
      # :company_preference
      )
  end
  
end

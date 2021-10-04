class JobsController < ApplicationController
  include Pundit
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :authenticate_user!, except: %i[index show guest_person_apply]
  before_action :set_job, only: %i[show edit update destroy]

  after_action :generate_scores, only: %i[create update]
  before_action :set_referral_token, only: [:show], if: -> { params[:token].present? }

  # GET /jobs
  def index
    @isCandidate = current_user&.talent?
    @total_entries = Job.all.count

    if current_user&.role == 'employer' || current_user&.role == 'recruiter'
      @jobs = current_user.jobs.all.page(params[:page]).per(25)
      @total_entries = current_user.jobs.count
    elsif current_user&.role == 'talent'
      @jobs = Job.all.page(params[:page]).per(25).map do |job|
        job_hash = job.to_hash
        job_hash[:score] = job.match_scores.all.select { |score| score.person_id == current_user.person_id }[0].score if current_user.person_id
        job_hash
      end
    else
      @jobs = Job.all.page(params[:page]).per(25)
    end
    @jobs = @jobs.map { |job| job.to_hash }

    respond_to do |format|
      format.html
      format.json { render json: {jobs: @jobs, jobsCount: @total_entries} }
    end
  end

  def search_jobs
    person = Person.find_by(user_id: current_user.id)
    person_job_attributes = JobSearch.person_job_search_attributes
    @job_search = JobSearch.create!(person_job_attributes.each { |job_attrs, person_attrs| person_job_attributes[job_attrs] = person[person_attrs] })
    redirect_to @job_search
  end

  # GET /jobs/1
  def show
    if @job.blank? || (!@job.active && current_user.blank?)
      render_404
      return
    end

    if current_user
      if current_user.person_id
       @match_score = @job.match_scores.where(person_id: current_user.person_id).first.try(:score)
      end
     @is_applied = current_user.talent? && @submitted_candidates.include?(@person_id)
     @current_organization = current_user&.organization
     @applied_date = @job.submissions.find_by(user_id: current_user.id).try(:created_at)
     begin
      email_address = OutgoingMailService.retrieve_email_credentials(current_user.email).payload.parsed_response["email_address"]
     rescue 
      logger.info "email not found"
     end
    end
    @url = "#{ENV["HOST"]}/jobs/#{@job.try(:id)}"
    name_param = @job.name.parameterize  
    request_url = request.original_url
    text_after_id = request_url.split("/").last
    @organizationId = @job.organization_id
    @organization = @job.organization
    @job_location = @job.locations.first    
    @job_status = @job.active
    @job_stage_count = @job.job_stage_status
    if current_user && current_user&.organization&.present?
      @member_organization = current_user&.organization&.is_cardinal_organization || current_user&.recruiter_organizations&.map(&:organization)&.map(&:is_cardinal_organization)&.include?(true)
    end  
    delete_invite_referral_session
    if text_after_id != @job.name.parameterize
      respond_to do |format|
       format.html {redirect_to "/jobs/#{@job.id}/#{name_param}"}
       format.json {}
      end
    end
  end

  def organization_name
    @organization =  Job.find(params[:id]).organization

    if !(@organization === current_user.organization) && !(@organization.name === 'CardinalTalent') && !(@organization.recruiter_organizations.include?(@organization))
      RecruiterOrganization.create(user: current_user, organization_id: @organization&.id, status: RecruiterOrganization::ACCEPTED)
    end
    render json: @organization  
  end

  # GET /jobs/new
  def new
    @job = Job.new
    @active_accounts = ManagedAccount.where(closed: false).order(:name)
    @organizations = get_organizations(Organization::APPROVED)
    pending_organizations = get_organizations(Organization::PENDING)

    if @organizations.nil? && pending_organizations.nil?
      redirect_to new_organization_path, notice: 'You must create or join an organization before you can post jobs.'
    elsif pending_organizations.present? && @organizations.nil?
      redirect_to organizations_path, notice: 'Once your organization is approved you will be able to post jobs. Typically this will take less than 24hrs.'
    end
  end

  # GET /jobs/1/edit
  def edit; end

  # POST /jobs
  def create
    @job = Job.new(create_params)
    if @job.save
      EmployerDashboard.create(job_id: @job.id, organization_id: @job.organization_id)
      
      if current_user.organization.status === Organization::APPROVED
        @job.job_post_live_email(current_user,@job)
      end

      if current_user.organization.status != Organization::APPROVED
        @job.job_post_pending_email(current_user,@job)
      end

      respond_to do |format|
        format.json { render json: @job.to_hash }
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
      end
    else
      respond_to do |format|
        format.json { render json: { error: @job&.errors&.full_messages[0] } }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /jobs/1
  def update
    updated_params = job_params.merge(create_params)
    unless @job.update(updated_params)
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
    if  @job.update(active: false)
      InterviewSchedule.where(job_id: @job.id)&.find_each do |interview_schedule|
        interview_schedule&.update(active: false)
        interview_schedule&.send_cancel_email_to_candidate
        interview_schedule&.send_cancel_email_to_recruiter
      end
      render json: {job: @job.to_hash, message: 'Job closed successfully '}
    else
      render json: {message: 'please try again'}
    end
  end

  def search
    search = JobSearch.find(params[:id])
    authorize search
    @job_search = search.query_search_engine_get_job
  end

  def get_relevant_candidates
    job = Job.find(params[:filters][:job_id])
    search = job.create_search_people
    people = search.query_search_engine_get_people(params[:page]).to_filtered_hash.each { |candidate| candidate[:score] = MatchScore.where(person_id: candidate[:id], job_id: @job.id)[0]&.score }
    render json: {
      total: people.total_count,
      total_pages: people.total_pages,
      people: people
    }
  end

  def fetch_submitted_candidates
    submitted_candidates_service = FetchSubmittedCandidatesService.new(
      params[:job_id], params[:page], params[:stage], job_applicants_search_params,
      current_user, params[:period_key], params[:filters][:email_type]
    )
    submitted_candidates_service.call
    render json: submitted_candidates_service.result_response
  end

  def generate_scores
    GenerateScoresJob.perform_later({ job_id: @job.id }) if !@job.id.nil?
  end

  def cardinal_member_organization_jobs
    organization  = Organization.find_by(name: 'CardinalTalent')
    organization_jobs = organization&.jobs.where(active: true)
    organization.sub_organizations&.each do |sub_organization|
      organization_jobs += sub_organization&.jobs&.where(active: true)
    end
    render json:  { jobs: organization_jobs, message: 'success'}
  end

  # TODO: Add seprate api endpoint
  def employer_home
    show_my_jobs = params['show_my_jobs'].present? ? ActiveRecord::Type::Boolean.new.cast(params['show_my_jobs']) : true
    show_my_closed_jobs = params['show_my_closed_jobs'].present? ? ActiveRecord::Type::Boolean.new.cast(params['show_my_closed_jobs']) : false
    respond_to do |format|
      format.html
      format.json do
        result = EmployerJobsService.new(current_user, params, own_jobs: show_my_jobs, closed_jobs: show_my_closed_jobs)
        result.call
        render json: result.jobs_data
      end
    end
  end

  def single_candidate_upload
  end

  def bulk_candidate_upload
    @organization_id = @current_user.organization.id
  end

  def send_import_jobs
    params[:jobs][:user_id] = current_user&.id
    ImportJob.create(import_job_params)
    BulkImportJob.perform_async
    AdministrativeMailer.send_email_about_import_job(import_job_params).deliver_now
  end
  
  def extend_job
    job = Job.find(params[:job_id])
    if job.update(expiry_date: job&.expiry_date + params[:no_of_days].to_i.days)
      render json: {message: 'Job extended successfully'}
    else
      render json: {message: 'Job extended failed'}
    end
  end

  def guest_person_apply
    person = Person.find_by(email_address: person_params['email_address'])
    @job = Job.find_by(id: params[:job_id])
    job_title = @job.name
    email_id = @job&.notificationemails
    # recruiter = User.find_by(id: @job.creator_id)
     if person.nil?
      begin 
        person = Person.create!(person_params) 
        # This code-breaking is my ongoing functionality Please check & do this & please use outgoing mail service 
        # GuestPersonMailer.sample_email(person, job_title, email_id, recruiter.first_name).deliver if person
      rescue => error
        render json: { error: 'Failed to Apply' }, status: 422
        return
      end
     else
        if person.update(person_params)
        # This code-breaking is my ongoing functionality Please check & do this use outgoing mail service 
        # GuestPersonMailer.sample_email(person, job_title, email_id, recruiter.first_name).deliver
        else
          render json: { error: 'Failed to Apply' }, status: 422
          return
        end
     end
    submission = Submission.find_by(job_id: params[:job_id], person_id: person.id)
    if submission.present?
     render json: { error: 'Already applyed' }, status: 422
    else
     begin
      submission = Submission.create!(job_id: params[:job_id], person_id: person.id)   
      stage = StageTransition.create(feedback: "Test", submission_id: submission.id, stage: "applicant" ) if submission.present?
      user_id = current_user&.id.present? ? current_user : ''
      JobStageStatus.stage_count(params[:job_id], user_id, submission) if stage.present?
      GenerateScoresJob.perform_now({ job_id: params[:job_id], person_id: person.id })
     rescue 
      render json: { error: 'Failed to Apply' }, status: 422
      return
     end
     render json: { message: 'Applied successfully' }
    end
  end
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    if current_user
      @job = Job.includes(submissions: :stage_transitions).find(params[:id])
      @submissions = JSON.parse(@job.submissions.to_json(include: [:stage_transitions]))
      @submitted_candidates = @job.submissions.pluck(:person_id)
      @person_id = Person.find_by(email_address: current_user&.email).try(:id)
    end
      @job = Job.find_by(id: params[:id])
  end

  def person_params
    params.require(:candidate).permit(
      :first_name,
      :last_name,
      :email_address,
      :phone_number,
      :resume,
      :linkedin_profile_url,
      :skills,
      :school
    )
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
      :department
      )
  end

  def get_organizations(status)
    current_user.own_organization if current_user.own_organization&.status == status
  end

  def import_job_params
    params.require(:jobs).permit(
      :notificationemails,
      :company_name,
      :job_file,
      :organization_id,
      :user_id
    )
  end

  def job_applicants_search_params
    params.require(:filters).permit(
      :active, :top_school, :tags, :names, :emails,
      :phone_number_available, :titles, :skills, :locations,
      :degrees, :disciplines, :schools, :company_names, :top_company, :keyword
    )
  end

  def set_referral_token
    session[:referral_token] = params[:token]
  end

  def delete_invite_referral_session
    @show_invite_friends = session[:referral_token].present? && session[:invite_friends].present? ? true : false
    session.delete(:invite_friends)
    session.delete(:job_id)
    session.delete(:apply_job)
  end

  def convert_to_interger(val)
    val.split(',').map{ |x| x.to_i } if val
  end

  def convert_to_boolean(val)
    ActiveRecord::Type::Boolean.new.cast(val) if val
  end

  def create_params
    if params[:id]
      create_params = {}
    else
      organization = current_user.organization if current_user.organization
      create_params = { user: current_user, organization: organization } .merge(job_params)
      create_params[:notificationemails] = current_user.email if job_params[:notificationemails] == "undefined"
      create_params[:expiry_date] = DateTime.now + 30.days
    end
    create_params[:location_ids] = convert_to_interger(params[:job][:location_names])
     
    if(create_params[:location_ids].present?)
      create_params[:location_preference] = "Specify"
    end
    
    create_params[:status] = Organization::employer_organization_status(current_user) == Organization::APPROVED ? Job.statuses[:active] : Job.statuses[:pending]
    create_params[:user_education_ids] = convert_to_interger(params[:job][:school_names])
    create_params[:company_profile_ids] = convert_to_interger(params[:job][:company_names])
    create_params[:school_names] = params[:job][:education_preference]
    create_params[:company_names] = params[:job][:company_preference]
    create_params[:referral_candidate] = convert_to_boolean(params[:job][:referral_candidate])
    create_params
  end

end

class PeopleSearchesController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!


  before_action :set_user, only: [:show, :edit, :update]
  before_action :redirect_cancel, only: [:create, :update]
  #respond_to :html, :json
 

  ##
  # submit from the from goes here
  def create
    Rails.logger.tagged("Creating search") { logger.debug(search_params) }
    @search = PeopleSearch.new(search_params)
    authorize @search
    if @search.save
      current_user.people_searches << @search
      #redirect_to @search
      respond_to do |format|
        format.json { render json: @search }
      end
    else
      flash[:error] = "There was an error performing this search. Please try again."
    end
  end

  ##
  # bookmark: The actual search for the candidates is performed here
  def show
    @clean_ui = params['clean_ui']
    @search = PeopleSearch.find(params[:id])
    authorize @search
    @people = @search.query_search_engine_get_people params[:page]
    @all_people_count = @people.total_count
    @people = Person.where(id: @people.collect(&:id)).includes(:submissions)
    @ppl = []
    email_address = OutgoingMailService.retrieve_email_credentials(current_user.email).payload.parsed_response["email_address"]
    email_address.present? ? @is_email_credential = true : @is_email_credential = false
    people_ids = @people.pluck(:id)
    searched_candidates_ids = current_user.searched_candidates.pluck(:person_id) 
    unsearched_candidates_ids = people_ids - searched_candidates_ids 
    unsearched_candidates_ids.each do |unsearched_candidate_id|
      current_user.searched_candidates.create!(person_id: unsearched_candidate_id)
    end
    @searches = current_user.people_searches.last(3)
    @jobs = Job.all.as_json(only: [:id, :name])
  end

  def new
    @search = PeopleSearch.new
    authorize @search
    email_address = OutgoingMailService.retrieve_email_credentials(current_user.email).payload.parsed_response["email_address"]
    logger.info "Email Address Credentials #{email_address}"
    email_address.present? ? @is_email_credential = true : @is_email_credential = false
    @current_user_organization_jobs = current_user&.organization&.jobs&.where(active: true)
    if current_user && current_user.organization.present?
      @member_organization = current_user.organization.is_cardinal_organization || current_user.recruiter_organizations.map(&:organization).map(&:is_cardinal_organization).include?(true)
    end  
    # Create new searches that filter by active status automatically
    # for employer accounts and recruiter accounts
    # Rails.logger.info "comapnys +++++++++++++++++++++++++++++  #{@companys} +++++++++++++++++++++++++++++++++" 
    if current_user.role == 'employer' || current_user.role == 'recruiter'
      @search.active = true
    end

    @searches = current_user.people_searches.last(3)
  end

  def edit
    @search = Search.find(params[:id])
    authorize @search
  end




  def index
    @search = current_user.people_searches.order(:name).page(params[:page])
    authorize @search
  end

  def update
    @search = PeopleSearch.create!(search_params)
    authorize @search
    redirect_to @search
  end

  def destroy
    @search = PeopleSearch.find(params[:id])

    if @search.destroy!
      redirect_back_or user_path(current_user)
      flash[:notice] = "Search was deleted successfully."
    else
      redirect_back_or user_path(current_user)
      flash[:error] = "There was an error deleting this search. Please try again."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def move_candidate_tostage
    person_ids = params[:candidate_ids].split(',').map(&:to_i)
    job_id = params[:job_id]
    user_id = current_user.id
    if (person_ids.count <= 25)
      person_ids.each do |person_id|
        submission = Submission.find_by(person_id: person_id, job_id: job_id)
        stage = StageTransition.where(submission_id: submission.id)&.last if submission.present?
        submission = Submission.create(user_id: user_id, person_id: person_id, job_id: job_id) if !submission.present?
        stage = StageTransition.create(feedback: "Test", submission_id: submission.id, stage: 'lead') if submission.present?
        JobStageStatus.stage_count(job_id, user_id, submission) if stage.present?
        GenerateScoresJob.perform_later({ job_id: job_id, person_id: person_id })
      end
      render json: {message: 'Successfully move to ATS'}, status: 200
    else
      render json: {message: 'Only 25 candidates can move to ATS at a time'}
    end
  end

  private

  def redirect_cancel
    redirect_to new_people_search_path if params[:cancel]
  end

  def set_user
    @user = current_user
  end

  def search_params
    params
      .require(:people_search)
      .permit(:id,
        :keyword,
        :active,
        :company_names,
        :disciplines,
        :degrees,
        :emails,
        :locations,
        :min_education_level,
        :names,
        :phone_number_available,
        :schools,
        :skills,
        :titles,
        :top_company,
        :top_school,
        :tags
      )


  end

  def user_not_authorized
    flash[:alert] = "Your account needs to be reviewed and approved before you can perform searches."
    redirect_to(request.referrer || '/')
  end
end

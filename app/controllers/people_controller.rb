require 'csv'
class PeopleController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :filter_params, only: [:search]
  before_action :set_user, only: %i[show edit update destroy index add_single_candidate]

  after_action :generate_scores, only: [:create, :update]
  PERSONAL = "Personal"
  COMPANY = "Company"
  EMAIL = "@gmail.com"
  respond_to :html, :json
  skip_before_action :authenticate_user!, :only => [:update_user_profile]

  def create_update
    begin
      real_params = person_params.to_hash.transform_keys { |k| k.to_sym }.compact
      @person = nil
      if(params["id"].present?)
        @person = Person.find(params["id"])
        real_params.delete(:experiences) if real_params.include?(:experiences)
        @person.update(real_params)
        job_exp_arr = JSON.parse(params['person']['experiences']) rescue []
        job_exp_arr.each do |params|
          job_exp = JobExperience.find_by(id: params['id']) rescue nil
           if job_exp.nil?
            JobExperience.create!(params.merge({person_id: @person.id})) 
           else
            job_exp.update!(params)
           end
        end
      else
        real_params[:user] = current_user
        real_params[:source] = Person::SOURCE[:system]
        @person = Person.create(real_params)
      end
    rescue ActiveRecord::StatementInvalid  => e
      render plain: "You either didn\'t enter email address in the form, or it already exists in the system. #{e.message}", status: 400
    else
      respond_to do |format|
        format.html { redirect_to '/', notice: "Person (id = #{@person.id}) was successfully saved." }
        format.json { render json: {updatedPerson: @person.to_filtered_hash, message: 'Update successful.'} }
      end
    end
  end

  def create
    create_update
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    create_update
  end

  def generate_scores
    GenerateScoresJob.perform_later({person_id: @person.id, job_id: params[:job_id]}) if !@person.id.nil?
  end

  def show
    @person = Person.find(params[:id])
    authorize @person
    if(@person.organization_id.nil? || current_user.organization_id.nil?)
      if  (!@person.user_id.nil? && @person.user_id == current_user.id)
       is_editable = true
      else
       is_editable = false
      end
    else    
      is_editable = @person.organization_id == current_user.organization_id || @person.user_id == current_user.id
    end
    unless current_user
      flash.now[:alert] = "You must be signed in to view people."
      redirect_to new_session_path
      return
    end

    notes = current_user.admin? ?
      @person.notes.as_json(include: :user) :
      @person.notes.where(organization_id: current_user.organization_id).as_json(include: :user)

    resume = nil
    resume_url = nil
    has_resume = @person.try(:resume).try(:attached?) || @person.try(:resume_text).present?
    if has_resume
      resume = @person.resume.blob if @person&.resume&.attached?
      resume_url = @person.resume_url if @person&.resume&.attached?
    end

    personDto = {
      person: @person.to_filtered_hash,
      job_experiences: @person.job_experiences || [],
      notes: notes,
      jobs: Job.all.map{ |j| [ j.id, j.name, j.portalcompanyname] },
      submissions: @person.submissions.map{ |s| s.to_s},
      currentUser: current_user,
      currentOrganization: current_user.organization ? current_user.organization.name : nil,
      resume: resume,
      resume_url: resume_url,
      linkedin_url: @person.linkedin_profile_url,
      github_url: @person.github_url,
      is_editable: is_editable
    }

    respond_to do |format|
      format.html
      format.json { render json: personDto }
    end
  end


  def update_user_profile
    people = Person.find(params[:id])
    people.update_avatar(params[:user_url]) unless people&.avatar&.attached?
    if people.save!
      render json: {message: 'updated succesfully'}, status: 200
    else
      render json: {message: 'somethiing went wrong'}
    end
  end

  ##################### legacy code

  def index
    @people = if params[:query].present?
    Person.search params[:query]
              else
                current_user.people.order('created_at DESC').paginate(page: params[:page], per_page: 5)
              end

    @follows = @user.all_follows
    @call_sheets = CallSheet.where(user_id: @user.id)
    @searches = PeopleSearch.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @people = Person.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)&.map { |item| item.to_filtered_hash }
    @notes = Note.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @submitted_candidates = SubmittedCandidate.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @candidate_submittals = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @hidden_candidates = @follows.blocked
    @requested_candidates = @follows.unblocked
    @candidate_requests = SubmittedRequest.where(recruiter_id: @user.id, hidden_status: false).paginate(page: params[:page], per_page: 5)
    @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
  end

  def autocomplete
    render json: Person.search(params[:query],
                               fields: ["name"],
                               match: word_start,
                               limit: 10,
                               load: false,
                               misspellings: { below: 5 }).map(&:title)
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      flash[:notice] = "Person was deleted successfully."
      redirect_to user_dashboard_path(current_user)
    else
      flash[:error] = "There was an error deleting this person. Please try again."
      render :show
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_flag_for_review_from_member
    @person = Person.find(params[:person])
    @user = User.find(params[:user])
    @person.flag = true

    if @person.save!
      redirect_to :back, notice: "Successfully flagged."
    else
      redirect_to :back, notice: "There was an error while saving. Please try again."
    end
  end

  def mark_complete
    Person.where(id: params[:people_ids]).update_all active: true
    redirect_to :back, notice: 'Actively set'
  end

  def import_candidate_linkedin_url
    @recepients ||= Person.where(id: params[:list_of_recipient_ids].scan(/\d+/))
    linkedin_url = @recepients.pluck(:first_name, :last_name, :linkedin_profile_url)
    csv_data = CSV.generate do |csv|
      csv << [ "first_name","last_name","linkedin_url"]
      linkedin_url.each do |array|
        csv << [array[0], array[1], array[2]]
      end
    end
    send_data(csv_data, :type => 'text/csv', :filename => 'data.csv') 
  end

  def edit_multiple
    @people = Person.find(params[:people_ids])&.map { |item| item.to_filtered_hash }
  end

  def my_leads
    search = PeopleSearch.create({user_id: current_user.id})
    search_response = search.query_search_engine_get_people(params[:page])
    render json: {
      total: search_response.total_count,
      total_pages: search_response.total_pages,
      people: search_response
    }
  end

  def update_multiple
    @people = Person.find(params[:people_ids])
    @people.reject! do |person|
      person.update_attributes(params[:person].reject { |k, v| v.blank? })
    end
    if @people.empty?
      redirect_back(fallback_location: user_dashboard_path(current_user), notice: 'Updates successful.')
    else
      render "edit_multiple"
      flash[:notice] = 'Updates were unsuccessful.'
    end
  end

  def send_bulk_email_messages
    @people = Person.find(params[:people_ids])
    @people_ids = []
    @people.each do |p|
      @people_ids << p.id
    end
    redirect_to new_message_path(recipients: @people_ids)
  end

  def search
    params[:filters][:keyword] = "#{default_search_params[:keyword]}"
    search = PeopleSearch.create(default_search_params)
    search_response = search.search_for_leads(
      current_user, params[:page], params[:period_key],
      params[:count], params[:job_id], @company_type, ActiveRecord::Type::Boolean.new.cast(params[:with_score])
    )
    logger.info "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    logger.info search_response
    render json: search_response
  end

  def add_single_candidate
    ActiveRecord::Base.transaction do
      begin
        @person = Person.create!(person_params)
        JobExperience.create!(job_experience_params(@person))
        GenerateScoresJob.perform_now({ job_id: params[:job_id], person_id: @person&.id }) if params[:job_id].present? && !@person.id.nil?
        submission = Submission.new(job_id: params[:job_id], person_id: @person&.id, user_id: current_user&.id)
        submission.change_stage(feedback: 'Test', stage: params[:stage]) if submission.save!
       
        @job = Job.find_by(id: params[:job_id])
        content = OutgoingEmailsHelper.add_single_candidate_email(@job, @person, @user)
        JobEmailer::send_email_to_user_for_newly_add_candidate_for_job(email: @user.email, content: content)
        render json: { success: true, type: 'success', msg: 'candidate added succesfully' }
      rescue => error
        Rails.logger.debug "Failed to add candidate: #{error}"
        # render json: {success: false, type: 'failure', msg: 'candidate not created, please check your email address'}
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def filter_params
    filter_email_type = params.dig(:filters, :email_type)
    if filter_email_type.present? && (filter_email_type == PERSONAL || filter_email_type == COMPANY)
      @company_type = filter_email_type
    end
  end

  def default_search_params
    params.require(:filters).permit(:active, :top_school, :tags,
    :names, :emails, :phone_number_available,
    :titles, :skills, :locations, :degrees, :disciplines, :schools, :company_names, :top_company, :keyword)
  end

  def set_user
    @user = current_user
  end

  def person_params
    params[:person][:links] = (JSON.parse(params.dig(:person, :links)) || []) if params.dig(:person, :links).class.to_s == 'String'
    params[:person][:links] = [] if params.dig(:person, :links).class.to_s == 'String' && !params[:person][:links].present?
    params.require(:person)
    .permit(
      :id,
      :active,
      :user_id,
      :first_name,
      :last_name,
      :formatted_name,
      :search_text,
      :skills,
      :school_names,
      :degrees,
      :keyword,
      :location,
      :employer,
      :title,
      :school,
      :degree,
      :discipline,
      :source,
      :experiences,
      :name,
      :min_time_in_job,
      :organization_id,
      :max_time_in_job,
      :min_career_length,
      :max_career_length,
      :min_activity_date,
      :max_activity_date,
      :linkedin_available,
      :phone_number,
      :phone_number_available,
      :github_available,
      :linkedin_profile,
      :company_position,
      :email_address,
      :linkedin_field_of_study,
      :linkedin_industry,
      :linkedin_profile_education,
      :linkedin_profile_position,
      :linkedin_profile_publication,
      :linkedin_profile_recommendation,
      :linkedin_profile_url_resource,
      :linkedin_school,
      :avatar,
      :avatar_url,
      :avatar_file_name,
      :avatar_content_type,
      :avatar_updated_at,
      :document,
      :document_url,
      :document_file_name,
      :document_content_type,
      :document_updated_at,
      :work_authorization_status,
      :salary_details,
      :salary,
      :salutation,
      :file,
      :recently_added,
      :user,
      :message,
      :body,
      :subject,
      :recipients,
      :conversation,
      :user_id,
      :message,
      :company_names,
      :title,
      :education_level,
      :description,
      :remote_interest,
      :position_interest,
      :experience_years,
      :visa_status,
      :job_search_stage,
      :industry,
      :specialties,
      :summary,
      :person,
      :utf8,
      :authenticity_token,
      :commit,
      :resume,
      :tags,
      :linkedin_profile_url,
      :github_url,
      links: [],
      person: %i[user_id attached_document document salutation first_name last_name email_address phone_number linkedin_profile_url, location, description, salary, salary_details remote_interest position_interest experience_years job_search_stage industry skills specialties summary],
      message: %i[subject body],
      recipients: [],
      uploads: %i[id utf8 authenticity_token created_at updated_at document_file_name document_content_type document_file_size document_updated_at user_id person file],
      recruiter_updates: %i[id utf8 authenticity_token created_at updated_at file recruiter_update_id status notes date role client lead_source email phone_number visa company school linkedin_url first_name last_name name archived user_id job_id account_id status_id person file],
      linkedin_profiles: %i[id utf8 authenticity_token created_at updated_at public_profile_url person file],
      email_addresses: %i[email person file],
      phone_numbers: %i[value person file],
      notes: %i[body user_id],
      users: %i[id ut8 authenticity_token person]
    )
  end

  def job_experience_params(person)
    params['person']['experiences'] = JSON.parse(params['person']['experiences']).map {|h| h.merge(person_id: person.id)}
  end
end


class UsersController < ApplicationController
  protect_from_forgery
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, except: [:confirm_email, :exists]
  before_action :set_user, except: [:confirm_email, :exists, :get_email]
  before_action :skip_password_attribute, only: :update

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    @person = @user.people.first_or_create

    if @user.save!
      @person.save!
      session[:user_id] = @user.id
      redirect_to after_signup_path
    else
      redirect_back_or root_path
      flash[:alert] = "Your profile couldn't be created due to the following: " + @user.errors.messages.map { |k,v| v }.join('<br>').html_safe
    end
  end

  # GET /users/:id.:format
  def show
    @follows = @user.all_follows
    @call_sheets = CallSheet.where(user_id: @user.id)
    @searches = Search.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @people = Person.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @notes = Note.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @submitted_candidates = SubmittedCandidate.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)

    @candidate_submittals = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @hidden_candidates = @follows.blocked
    @requested_candidates = @follows.unblocked
    @candidate_requests = SubmittedRequest.where(candidate_id: @user.id)
    @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
    @searched_candidates = current_user.searched_candidates.all

    # @latest_interviews = current_user.bookings.page(params[:page]).per(3)
  end

  def searched_candidates
    @candidate_interviews = Interview.where(user_id: @user.id)
    @latest_conversations = @user.mailbox.conversations.page(params[:page]).per(3)
    @follows = @user.all_follows
    @call_sheets = CallSheet.where(user_id: @user.id)
    @searches = Search.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @people = Person.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @notes = Note.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @submitted_candidates = SubmittedCandidate.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)

    @candidate_submittals = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @hidden_candidates = @follows.blocked
    @requested_candidates = @follows.unblocked
    @candidate_requests = SubmittedRequest.where(candidate_id: @user.id)
    @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
    @searched_candidates = current_user.searched_candidates.all
    @favorites = current_user.saved_candidates.all
  end

  def dashboard
    if @user.sign_in_count == 1 && @user.role == 'guest'
      session[:alerted] = true
    else
      session[:alerted] = false
    end

    if @user.sign_in_count == 1 && @user.role == 'guest'
      session[:modal] = true
    else
      session[:modal] = false
    end

    @follows = @user.all_follows
    @call_sheets = CallSheet.where(user_id: @user.id)
    @searches = Search.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @people = Person.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @notes = Note.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @submitted_candidates = SubmittedCandidate.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)

    @candidate_submittals = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @hidden_candidates = @follows.blocked
    @requested_candidates = @follows.unblocked
    @candidate_requests = SubmittedRequest.where(candidate_id: @user.id)
    @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
    @searched_candidates = current_user.searched_candidates.all

  end

  # GET /users/:id/edit
  def edit
    @follows = @user.all_follows
    @call_sheets = CallSheet.where(user_id: @user.id)
    @searches = Search.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @people = Person.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @notes = Note.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @submitted_candidates = SubmittedCandidate.where(user_id: @user.id).paginate(page: params[:page], per_page: 5)
    @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
    @hidden_candidates = @follows.blocked
    @requested_candidates = @follows.unblocked
    @candidate_requests = SubmittedRequest.where(candidate_id: @user.id)
    @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
  end

  # PATCH/PUT /users/:id.:format
  def update
   
    if current_user.update(user_params.except(:email))
        render json: { person: current_user, message: "Updated Successfully"}
    else
         render json: { error: current_user.errors.full_messages[0] }
    end
    
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    @user = User.find(params[:id])

    if request.patch? && params[:user]
      if @user.update(user_params)
        @user.save

        # Re-enable this method if using the Devise Confirmable module
        # @user.skip_reconfirmation!
        bypass_sign_in(@user)
        redirect_to user_dashboard_path(@user), notice: 'Your profile was successfully saved.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Your profile was successfully deleted.' }
    end
  end

  def autocomplete
    render json: User.search(params[:query], {
      fields: ["name"],
      match: word_start,
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map(&:title)
  end

  def profile
    @person = Person.find_by(email_address: current_user&.email)
    @resume_name = @person&.resume&.attached? ? @person&.resume&.filename : ''
    @profile_pic_name = @person&.avatar&.attached? ? @person&.avatar&.filename : ''
  end

  # GET:: /users/<toekn>/confirm_email
  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    organization = user.organization

    if user.present? && user.email_activate
      UserEmailer::send_account_verified_email(reciptent_email: user.email, name: user.first_name)
      if user.employer?   
        if organization.is_official_email?(owner_email: user.email)
          user.organization.update(status: Organization::APPROVED) if user.employer?
          #send email for allow job posting
          UserEmailer::notify_employer_job_posting_status(reciptent_email: user.email, name: user.first_name)
        else
          #send email for decline job posting
          UserEmailer::notify_employer_job_posting_pending_status(reciptent_email: user.email, name: user.first_name)
        end
      end
       flash[:success] = "Your email has been confirmed. Please sign in to continue."
       redirect_to new_user_session_path
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_path
    end
  end

  def exists
    user = User.find_by(email: params[:email])
    render json: { user_exists: user.present? }
  end

  # Todo:
  # Move to seperate controller
  def setting
  end

  # Todo:
  # Move to seperate controller
  def security
  end

  # Todo:
  # Move to seperate controller
  def email_verification; end

  def security_update

    if current_user.valid_password?(params[:current_password])
      if current_user.update(password_params)
        render json: { person: current_user, message: "Password changed" }
      else
       render json: { message: current_user.errors.full_messages[0] } 
      end
    else
      render json: { message: 'Invalid Password' }   
    end 
     
  end
  def get_email
    user = User.find_by(id: params[:id])
    render json: { user: user }
  end


  private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end

    def set_user
      if current_user
        @user = current_user
      end
    end

    def skip_password_attribute
      if params[:password].blank? && params[:password_confirmation].blank?
        params.except(:password, :password_confirmation)
      end
    end

    def user_params
      accessible = [
        :google_token,
        :google_refresh_token,
        :avatar,
        {:avatar => [:avatar,
          :name,
          :content_type,
          :original_filename,
          :headers]},
        :location,
        :provider,
        :uid,
        :full_name,
        :person_id,
        :notes_id,
        :identity_id,
        :name,
        :email,
        :username,
        :first_name,
        :last_name,
        :date_of_birth,
        :signuprole,
        { :signuprole => [
          :talent,
          :employer,
          :recruiter
        ]},
        :active_job_seeker,
        :employer_hiring_roles,
        { :employer_hiring_roles => [
          :technical,
          :non_technical,
          :recruiter,
          :finance
          ]},
        :remember_me,
        :password,
        :password_confirmation,
        :nickname,
        :location_interest_bh,
        :location_interest_usa,
        :remote_interest,
        :position_interest,
        :skills,
        :experience_years,
        :address_line_1,
        :address_line_2,
        :city,
        :state,
        :zipcode,
        :supervising_num,
        :salary_expectations,
        :work_authorization_status,
        :visa_status,
        :linkedin_profile_url,
        :github_url,
        :personal_site,
        :stack_overflow_url,
        :position_desc,
        :employment_sought,
        { :employment_sought => [
          :permanent,
          { :permanent => [
            :on
            ]
          },
          :remote,
          :contract,
          :no_pref
        ]},
        :referred_from,
        :resume,
        :job_title,
        :job_ids,
        :company_name,
        :company_url,
        :remote_interest,
        :skills,
        :location_interest_usa,
        :location_interest_bh,
        :position_interest,
        :experience_years,
        :supervising_num,
        :salary_expectations,
        :work_authorization_status,
        :resume_content_type,
        :resume_file_size,
        :resume_updated_at,
        :accepts,
        :accepts_date,
        :employer_hiring_location,
        :employer_roles,
        :employer_roles_type,
        :employer_remoteness,
        :employer_timeframe,
        :employer_pricing_authorization,
        :start_date_month,
        :start_date_year,
        :end_date_month,
        :end_date_year,
        :company_size,
        :person,
        :message,
        :recipients,
        :utf8,
        :_method,
        :authenticity_token,
        :user,
        :commit,
        :job_search_stage,
        :phone_number,
        :company_name,
        :title,
        :start_date_month,
        :start_date_year,
        :end_date_month,
        :end_date_year,
        :company_url,
        :company_size,
        :current_position,
        :current_employer,
        :github_profile_url,
        company_position: [
          :is_current,
          :start_date,
          :start_date_year,
          :start_date_month,
          :end_date,
          :end_date_year,
          :end_date_month,
          :title
        ],
        linkedin_profile_position: [
          :company_name,
          :title,
          :start_date_month,
          :start_date_year,
          :end_date_month,
          :end_date_year,
          :is_current
        ],
        linkedin_profile_positions_attributes: [
          :id,
          :_destroy,
          :company_name,
          :title,
          :start_date_month,
          :start_date_year,
          :end_date_month,
          :end_date_year,
          :is_current
        ],
        linkedin_profile_educations_attributes: [
          :id,
          :_destroy,
          :school_name,
          :degree,
          :field_of_study,
          :start_date_year,
          :gpa
        ],
      ]
      params.require(:user).permit(accessible)
    end
end

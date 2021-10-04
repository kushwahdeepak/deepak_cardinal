class AfterSignupController < ApplicationController
  include Wicked::Wizard
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_user
  steps :step_one, :step_two, :step_three, :step_four



  def show
    # Refine the logic here -- what should happen when a user hits this page
    # users/after_signup_path -- when they just hit "Apply"?
    #

    if @user.role == 'talent'
      redirect_to '/'
    elsif @user.role == 'employer' || @user.role == 'recruiter'
      redirect_to '/employer_home'
    else
      redirect_to "/"
    end
    # if @user == nil
    #   redirect_to new_user_registration_path
    # end
    #
    # @candidate_interviews = Interview.where(user_id: @user.id).first_or_initialize
    #
    # @latest_conversations = @user.mailbox.conversations.page(params[:page]).per(3)
    #
    # if @user.current_position?
    #     @selection_position = @user.current_position
    #   elsif @user.positions?
    #     @selection_position = @user.positions.title
    #   else
    #     @selection_position = ''
    # end
    #
    # if @user.current_employer?
    #     @selection_employer = @user.current_employer
    #   elsif @user.positions?
    #     @selection_employer = @user.positions.company
    #   else
    #     @selection_employer = ''
    # end
    #
    # case step
    # when :step_one
    #   skip_step if @user.signuprole == "recruiter"
    #   skip_step if @user.signuprole == "employer"
    # when :step_two
    #   skip_step if @user.signuprole == "recruiter"
    # when :step_three
    #   skip_step if @user.signuprole == "recruiter"
    #
    # # when :step_two
    # #   skip_step if @user.signuprole == "employer"
    # # when :step_three
    # #   skip_step if @user.signuprole == "employer"
    # when :step_four
    #   skip_step
    #   skip_step if @user.signuprole == "employer"
    #   skip_step if @user.signuprole == "recruiter"
    #   skip_step if @user.signuprole.nil?
    #
    #   @linkedin_profile_position = @user.linkedin_profile_positions.first_or_initialize
    # # when :welcome
    # #   skip_step if @user.signuprole != "employer"
    # end
    #
    # if @user.signuprole == 'talent'
    #   @step_two_question_one = "What type of roles are you interested in?"
    #   @step_two_question_two = "Where would you like to work? (Please select at least one.)*"
    #   @step_two_question_three = "Are you authorized to lawfully work in the United States?*"
    #   @step_two_question_four = "Will you now or in the future require sponsorship for employment visa status (i.e. H1B visa)?*"
    #
    #   if @user.position_interest != nil
    #     @step_three_question_one = "How many years of experience do you have in " + @user.position_interest + "?"
    #   else
    #     @step_three_question_one = "How many years of experience do you have in technology?"
    #   end
    #   @step_three_question_two = "What full-time roles have you held?"
    #   @step_three_question_three = "Select your strongest skills."
    #   @step_three_question_four = "What roles are you most interested in?"
    #
    #   @step_four_question_one = "What type of employment are you seeking?"
    #   @step_four_question_two = "What is your desired salary?"
    #   @step_four_question_three = "Where are you in your job search?"
    #   @step_four_question_four = "What full time experience do you have?"
    #   @step_four_question_five = "Where did you go to school?"
    # elsif @user.signuprole == 'employer'
    #   @step_two_question_one = "What type of roles are you interested in hiring?"
    #   @step_two_question_two = "Where would you like to hire?* (Please select at least one.)"
    #   @step_two_question_three = "Are you hiring only people authorized to lawfully work in the United States?*"
    #   @step_two_question_four = "Are you hiring people who require sponsorship for employment visa status (i.e. H1B visa)?*"
    #     @step_three_question_one = "How many years of experience on average, should your talent have?"
    #   @step_three_question_two = "What full-time roles are you hiring?"
    #   @step_three_question_three = "Select the most important skills for candidates you hire (limit 3)."
    #   @step_three_question_four = "What roles are you most interested in hiring?"
    # else
    #   @step_two_question_one = "What type of roles are you interested in recruiting for?"
    #   @step_two_question_two = "Where would you like to recruit?* (Please select at least one.)"
    #   @step_two_question_three = "Are you authorized to lawfully work in the United States?*"
    #   @step_two_question_four = "Will you now or in the future require sponsorship for employment visa status (i.e. H1B visa)?*"
    #
    #   if @user.position_interest != nil
    #     @step_three_question_one = "How many years of experience do you have in recruiting for " + @user.position_interest + "?"
    #   else
    #     @step_three_question_one = "How many years of experience do you have in recruiting for technology roles?"
    #   end
    #   @step_three_question_two = "What full-time roles have you recruited for?"
    #   @step_three_question_three = "Select the skills you are most familiar with (limit 3)."
    #   @step_three_question_four = "What roles are you most interested in recruiting for?"
    #
    #   @step_four_question_one = "What type of recruiter employment are you seeking?"
    #   @step_four_question_two = "What is your desired hourly rate?"
    #   @step_four_question_three = "Where are you in your job search?"
    #   @step_four_question_four = "What experience do you have?"
    #   @step_four_question_five = "Where did you go to school?"
    # end
    #
    # if @user.signuprole == 'recruiter'
    #   @rate_options = [
    #     '$15 - $50',
    #     '$51 - $100',
    #     '$101 - $150',
    #     '$151+'
    #   ]
    # else
    #   @rate_options = [
    #     '$50,000 - $60,000',
    #     '$60,000 - $70,000',
    #     '$70,000 - $80,000',
    #     '$80,000 - $90,000',
    #     '$90,000 - $100,000',
    #     '$100,000 - $120,000',
    #     '$120,000 - $150,000',
    #     '$150,000 - $200,000',
    #     '$200,000+'
    #   ]
    # end
    #
    # render_wizard
  end

  def update
    set_user_hash
    set_signuprole
    set_expYears
    set_location_interest
    set_work_authorization
    set_visa_status
    set_remote_interest
    set_position_interest
    set_strongSkills
    set_roles_held
    set_salary
    set_job_search_stage
    set_employment_sought
    set_referral_site
    set_work
    set_education
    @user.save!(validate: false)
    render_wizard @user
  end

  def finish_wizard_path
    # Create person profile
    @person = @user.people.first_or_initialize
    @person.save!(validate: false)

    # Create and store formatted name
    @person.first_name = @user.first_name unless @user.first_name.blank?
    @person.last_name = @user.last_name unless @user.last_name.blank?
    unless @user.first_name.blank? || @user.last_name.blank?
      @person.formatted_name = @user.first_name + ' ' + @user.last_name
      @person.name = @user.first_name + ' ' + @user.last_name
    end

    # Create email address and set flags
    @email = @person.email_addresses.first_or_initialize
    @email.email = @user.email
    @person.email_address = @user.email
    @email.save!(validate: false)

    # Create linkedin profile and set flags
    unless @user.linkedin_profile_url.blank?
      @linkedin = @person.linkedin_profiles.first_or_initialize
      @linkedin.public_profile_url = @user.linkedin_profile_url
      @person.linkedin_profile_url = @user.linkedin_profile_url
      @person.linkedin_available = true
      @linkedin.save!(validate: false)
    end

    # Create and store person profile info
    @person.location = @user.location.name unless @user.location.blank?
    @person.skills = @user.skills unless @user.skills.blank?
    @person.work_authorization_status = @user.work_authorization_status unless @user.work_authorization_status.blank?
    @person.remote_interest = @user.remote_interest unless @user.remote_interest.blank?
    @person.position_interest = @user.position_interest unless @user.position_interest.blank?
    @person.experience_years = @user.experience_years unless @user.experience_years.blank?
    @person.supervising_num = @user.supervising_num unless @user.supervising_num.blank?
    @person.visa_status = @user.visa_status unless @user.visa_status.blank?
    @person.position_desc = @user.position_desc unless @user.position_desc.blank?
    @person.github_url = @user.github_url unless @user.github_url.blank?
    @person.github_available = true unless @user.github_url.blank?
    @person.personal_site = @user.personal_site unless @user.personal_site.blank?
    @person.personal_site_available = true unless @user.personal_site.blank?
    @person.title = @user.current_position unless @user.current_position.blank?
    @person.employer = @user.current_employer unless @user.current_employer.blank?
    @person.description = @user.employment_sought unless @user.employment_sought.blank?
    @person.salary_expectations = @user.salary_expectations unless @user.salary_expectations.blank?
    @person.visa_status = @user.visa_status unless @user.visa_status.blank?
    @person.job_search_stage = @user.job_search_stage unless @user.job_search_stage.blank?
    @person.position_desc = @user.position_desc unless @user.position_desc.blank?
    @person.industry = @user.industry unless @user.industry.blank?
    @person.current_share = @user.current_share unless @user.current_share.blank?
    @person.num_connections = @user.num_connections unless @user.num_connections.blank?
    @person.num_connections_capped = @user.num_connections_capped unless @user.num_connections_capped.blank?
    @person.summary = @user.summary unless @user.summary.blank?
    @person.specialties = @user.specialties unless @user.specialties.blank?
    @person.positions = @user.positions unless @user.positions.blank?
    @person.picture_url = @user.picture_url unless @user.picture_url.blank?

    # Set person record status based on signuprole and email
    if @user.signuprole == 'employer'
      @person.active = false
      @person.active_date_at = Date.today
      @person.active_set_by_user_id = @user.id
      @person.save!(validate: false)
      NewEmployerUserMailer.sample_email(@user).deliver
    end

    if @user.signuprole == 'recruiter'
      @person.active = false
      @person.active_date_at = Date.today
      @person.active_set_by_user_id = @user.id
      @person.save!(validate: false)
      NewRecruiterUserMailer.sample_email(@user).deliver
    end

    if @user.signuprole == 'talent'
      @person.active = false
      @person.active_date_at = Date.today
      @person.active_set_by_user_id = @user.id
      @person.save!(validate: false)
      NewTalentUserMailer.sample_email(@user).deliver
    end

    user_dashboard_path(@user)
  end

  def set_visa_status

    if @user.visa_status == nil
      if @user.user != nil
      if @user.user.include? "visa_yes"
        @user.visa_status = true
      elsif @user.user.include? "visa_no"
        @user.visa_status = false
      end
    end
    end
  end

  def set_work_authorization
    if @user.work_authorization_status == nil
      if @user.user != nil
      if @user.user.include? 'work_auth_yes'
        @user.work_authorization_status = true
      elsif @user.user.include? 'work_auth_no'
        @user.work_authorization_status = false
      end
    end
    end
  end

  def set_remote_interest
    if @user.remote_interest == nil
      if @user.user != nil
      if @user.user.include? 'Yes'
        @user.remote_interest = 'Yes'
      elsif @user.user.include? 'No'
        @user.remote_interest = 'No'
      end
    end
    end
  end

  #leaving note for myself to finish this - Shawn

  def set_location_interest
    if @user.user != nil
    if @user.user.include? 'berkeley'
      @user.location_interest_usa.push ("Berkeley")
    end
    if @user.user.include? 'no_loc_pref'
      @user.location_interest_usa.push ("No Location Preference")
    end
    if @user.user.include? 'chicago'
      @user.location_interest_usa.push ("Chicago")
    end
    if @user.user.include? 'oakland'
      @user.location_interest_usa.push ("Oakland")
    end
    if @user.user.include? 'san_diego'
      @user.location_interest_usa.push ("San Diego")
    end
    if @user.user.include? 'san_jose'
      @user.location_interest_usa.push ("San Jose")
    end
    if @user.user.include? 'san_francisco'
      @user.location_interest_usa.push ("San Francisco")
    end
    end
  end

  def set_company
    if step == :step_four
      # if @user_hash['linkedin_profile_position']['company_name']
      #   @user.linkedin_profile_positions.company_name = @user_hash['linkedin_profile_position']['company_name']
      #   @linkedin_profile_position.save!
      # end
      # if @user_hash['linkedin_profile_position']['title']
      #   @user.job_title = @user_hash['linkedin_profile_position']['title']
      # end
      # if @user_hash['linkedin_profile_position']['start_date_month']
      #   @user.start_date_month = @user_hash['linkedin_profile_position']['start_date_month']
      # end
      # if @user_hash['linkedin_profile_position']['start_date_year']
      #   @user.start_date_year = @user_hash['linkedin_profile_position']['start_date_year']
      # end
      # if @user_hash['linkedin_profile_position']['end_date_month']
      #   @user.end_date_month = @user_hash['linkedin_profile_position']['end_date_month']
      # end
      # if @user_hash['linkedin_profile_position']['end_date_year']
      #   @user.end_date_year = @user_hash['linkedin_profile_position']['end_date_year']
      # end
    end

  end

  def set_user_hash
    if @user.user != nil
      @user_input = @user.user
    else
      @user_input = ""
      @user.user = []
    end

    # Transform object string symbols to quoted strings
    @user_input.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')

    # Transform object string numbers to quoted strings
    @user_input.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')

    # Transform object value symbols to quotes strings
    @user_input.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')

    # Transform array value symbols to quotes strings
    @user_input.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')

    # Transform object string object value delimiter to colon delimiter
    @user_input.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    if @user_input != ""
      @user_hash = JSON.parse(@user_input)
      @user_hash
      if @user.user = nil
        @user.user = []
      end
    else
      @user_hash = {}
      if @user.user = nil
        @user.user = []
      end
      @user_input = {}
    end

  end


  def set_job_search_stage

    if @user.job_search_stage == nil
      if @user.user != nil
      if @user.user.include? 'actively'
        @user.job_search_stage = 'active'
      elsif @user.user.include? 'passive'
        @user.job_search_stage = 'passive'
      elsif @user.user.include? 'interview'
        @user.job_search_stage = 'interview'
      elsif @user.user.include? 'inactive'
        @user.job_search_stage = 'inactive'



    # if (@user.job_search_stage != nil)
    #   if @user.job_search_stage[5] == 'i'
    #     @user.job_search_stage = "active"
    #   elsif @user.job_search_stage[5] == 's'
    #     @user.job_search_stage = "passive"
    #   elsif @user.job_search_stage[5] == 'e'
    #     @user.job_search_stage = "interview"
    #   elsif @user.job_search_stage[5] = 'c'
    #     @user.job_search_stage = "inactive"
      end
      end
    end
  end

  def set_referral_site
    if @user.user != nil

      if @user.user.include? "googleSearch_site"
        @user.referred_from = "Google Search"
      elsif @user.user.include? "linkedin_site"
        @user.referred_from = 'Linkedin'
      elsif @user.user.include? "facebook_site"
        @user.referred_from = "Facebook"
      elsif @user.user.include? "instagram_site"
        @user.referred_from = "Instagram"
      elsif @user.user.include? "referral_site"
        @user.referred_from = "Referral"
      elsif @user.user.include? "other_site"
        @user.referred_from = "Other"
      end
    end
  end

  def set_employment_sought
    if @user.user != nil
      if @user.user.include? "permanent"
        @user.employment_sought = "permanent"
      elsif @user.user.include? "contract"
        @user.employment_sought = 'contract'
      elsif @user.user.include? "remote"
        @user.employment_sought = "remote"
      elsif @user.user.include? "no_pref"
        @user.employment_sought = "no preference"
      end
    end
  end

    # if @user.include? "position_interest"
  #   if (@user.employment_sought != nil)
  #     if @user.employment_sought[2] == 'p'
  #       @user.employment_sought = "permanent"
  #     elsif @user.employment_sought[2] == 'c'
  #       @user.employment_sought = "contract"
  #     elsif @user.employment_sought[2] == 'r'
  #       @user.employment_sought = "remote"
  #       # end
  #
  #     end
  #   end
  # end

  def set_position_interest

    # if @user.include? "position_interest"
    if (@user.position_interest != nil)
      if @user.position_interest[2] == 's'
        @user.position_interest = "Sales"
      elsif @user.position_interest[2] == 't'
        @user.position_interest = "Technology"
      elsif @user.position_interest[2] == 'f'
        @user.position_interest = "Finance"
        # end

      end
    end
  end

  def set_salary
    if @user_hash['salary_expectations']
      @user.salary_expectations = @user_hash['salary_expectations']
    end

  end

  def set_education
    if !(@user.linkedin_profile_educations.present?)
      @user.linkedin_profile_educations.first_or_initialize
    end
    if @user.user != nil
    if @user.user.include? "linkedin_profile_education"
      if @user_hash['linkedin_profile_education']['school_name']
        @user.linkedin_profile_educations.last.school_name = @user_hash['linkedin_profile_education']['school_name']
      end
      if @user_hash['linkedin_profile_education']['field_of_study']
        @user.linkedin_profile_educations.last.field_of_study = @user_hash['linkedin_profile_education']['field_of_study']
      end
      if @user_hash['linkedin_profile_education']['degree']
        @user.linkedin_profile_educations.last.degree = @user_hash['linkedin_profile_education']['degree']
      end
      if @user_hash['linkedin_profile_education']['start_date_year']
        @user.linkedin_profile_educations.last.start_date_year = @user_hash['linkedin_profile_education']['start_date_year']
      end
      if @user_hash['linkedin_profile_education']['gpa']
        @user.linkedin_profile_educations.last.gpa = @user_hash['linkedin_profile_education']['gpa']
      end
    end
    end
  end

  def set_work
    if !(@user.linkedin_profile_positions.present?)
      @user.linkedin_profile_positions.first_or_initialize
    end
    if @user.user != nil
    if @user.user.include? "linkedin_profile_position"
      # @user_hash['linkedin_profile_position'].each do |work|
        # @user.linkedin_profile_positions.new
        if @user_hash['linkedin_profile_position']['company_name']
          @user.linkedin_profile_positions.last.company_name = @user_hash['linkedin_profile_position']['company_name']
        end
        if @user_hash['linkedin_profile_position']['title']
          @user.linkedin_profile_positions.last.title = @user_hash['linkedin_profile_position']['title']
        end
        if @user_hash['linkedin_profile_position']['start_date_month']
          @user.linkedin_profile_positions.last.start_date_month = @user_hash['linkedin_profile_position']['start_date_month']
        end
        if @user_hash['linkedin_profile_position']['start_date_year']
          @user.linkedin_profile_positions.last.start_date_year = @user_hash['linkedin_profile_position']['start_date_year']
        end
        if @user_hash['linkedin_profile_position']['end_date_month']
          @user.linkedin_profile_positions.last.end_date_month = @user_hash['linkedin_profile_position']['end_date_month']
        end
        if @user_hash['linkedin_profile_position']['end_date_year']
          @user.linkedin_profile_positions.last.end_date_year = @user_hash['linkedin_profile_position']['end_date_year']
        end
      # end
    end
    end
  end

  def set_address
    if @user.user != nil
    if @user.user.include? "address_line_1"
      @user.address_line_1 = address_line_1
    end

    if @user.user.include? "address_line_2"
      @user.address_line_1 = address_line_2
    end

    if @user.user.include? "city"
      @user.city = city
    end

    if @user.user.include? "state"
      @user.state = state
    end

    if @user.user.include? "zipcode"
      @user.zipcode = zipcode
    end
  end
  end

  def set_signuprole
    if @user.user != nil
    if @user.user.include? "talent"
      @user.signuprole = :talent
    end

    if @user.user.include? "employer"
      @user.signuprole = :employer
    end

    if @user.user.include? "recruiter"
      @user.signuprole = :recruiter
    end
  end
  end

  def set_expYears
    if @user.user != nil
    if @user.user.include? "zero_plus"
      @user.experience_years = "0+"
    end

    if @user.user.include? "one_plus"
      @user.experience_years = "1+"
    end

    if @user.user.include? "two_plus"
      @user.experience_years = :"2+"
    end


    if @user.user.include? "three_plus"
      @user.experience_years = :"3+"
    end

    if @user.user.include? "four_plus"
      @user.experience_years = :"4+"
    end
  end
  end

  def set_strongSkills
    if @user.user != nil
    if @user.user.include? "Android"
      if !@user.skills.include? "Android"
        @user.skills.push("Android")
      end
    end

    if @user.user.include? "Angular_JS"
      if !@user.skills.include? "Angular_JS"
        @user.skills.push("Angular JS")
      end
    end

    if @user.user.include? "Automation_Testing"
      if !@user.skills.include? "Automation_Testing"
        @user.skills.push("Automation Testing")
      end
    end

    if @user.user.include? "AWS"
      if !@user.skills.include? "AWS"
        @user.skills.push("AWS")
      end
    end

    if @user.user.include? "C"
      if !@user.skills.include? "C"
        @user.skills.push("C")
      end
    end

    if @user.user.include? "C++"
      if !@user.skills.include? "C++"
        @user.skills.push("C++")
      end
    end

    if @user.user.include? "C#"
      if !@user.skills.include? "C#"
        @user.skills.push("C#")
      end
    end

    if @user.user.include? "Dev_Ops"
      if !@user.skills.include? "Dev_Ops"
        @user.skills.push("Dev Ops")
      end
    end

    if @user.user.include? "Django"
      if !@user.skills.include? "Django"
        @user.skills.push("Django")
      end
    end

    if @user.user.include? "Go"
      if !@user.skills.include? "Go"
        @user.skills.push("Go")
      end
    end

    if @user.user.include? "Hadoop"
      if !@user.skills.include? "Hadoop"
        @user.skills.push("Hadoop")
      end
    end

    if @user.user.include? "iOS"
      if !@user.skills.include? "iOS"
        @user.skills.push("iOS")
      end
    end

    if @user.user.include? "Java"
      if !@user.skills.include? "Java"
        @user.skills.push("Java")
      end
    end

    if @user.user.include? "Javascript"
      if !@user.skills.include? "Javascript"
        @user.skills.push("Javascript")
      end
    end

    if @user.user.include? "Machine_Learning"
      if !@user.skills.include? "Machine_Learning"
        @user.skills.push("Machine Learning")
      end
    end

    if @user.user.include? "Mongo_DB"
      if !@user.skills.include? "Mongo_DB"
        @user.skills.push("Mongo DB")
      end
    end

    if @user.user.include? "MySQL"
      if !@user.skills.include? "MySQL"
        @user.skills.push("MySQL")
      end
    end

    if @user.user.include? 'Node.js'
      if !@user.skills.include? "Node.js"
        @user.skills.push('Node.js')
      end
    end

    if @user.user.include? 'Objective-C'
      if !@user.skills.include? "Objective-C"
        @user.skills.push('Objective-C')
      end
    end

    if @user.user.include? 'PHP'
      if !@user.skills.include? "PHP"
        @user.skills.push('PHP')
      end
      @user.save!
    end

    if @user.user.include? 'Product_Design'
      if !@user.skills.include? "Product_Design"
        @user.skills.push('Product Design')
      end
    end

    if @user.user.include? 'Product_Management'
      if !@user.skills.include? "Product_Management"
        @user.skills.push('Product Managment')
      end
    end

    if @user.user.include? 'Python'
      if !@user.skills.include? "Python"
        @user.skills.push('Python')
      end
    end

    if @user.user.include? 'R_lang'
      if !@user.skills.include? "R_lang"
        @user.skills.push('R')
      end
    end

    if @user.user.include? 'React.js'
      if !@user.skills.include? "React.js"
        @user.skills.push('React.js')
      end
    end

    if @user.user.include? 'Scala'
      if !@user.skills.include? "Scala"
        @user.skills.push('Scala')
      end
    end

    if @user.user.include? 'Swift'
      if !@user.skills.include? "Swift"
        @user.skills.push('Swift')
      end
    end

    if @user.user.include? 'Technology_Management'
      if !@user.skills.include? "Technology_Management"
        @user.skills.push('Technology Management')
      end
    end


    if @user.user.include? 'UI/UX'
      if !@user.skills.include? "UI/UX"
        @user.skills.push('UI/UX')
      end
    end


    if @user.user.include? 'Security'
      if !@user.skills.include? "Security"
        @user.skills.push('Security')
      end
    end

    if @user.user.include? 'Ruby'
      if !@user.skills.include? "Ruby"
        @user.skills.push('Ruby')
      end
    end
  end
  end

  def set_roles_held
    if @user.user != nil
    if @user.roles_held == nil
      @user.roles_held = []
    end

    if @user.user.include? 'Product_Mgmt'
      @user.roles_held.push('Product Managment')
    end


    # if @user.user.include? ''
    #   if @user.skills.include?('') == false
    #     @user.skills.push('')
    #   end
    # end
  end
  end

  private

    def set_user
      if current_user
        @user = current_user
      else
        # Refine the logic here -- what should happen when a user hits this page
        # users/after_signup_path -- when they just hit "Apply"?
        if @user == nil
          redirect_to new_user_registration_path
        end
      end
    end

    def user_params
      accessible = [
        :job_ids,
        :utf8,
        :company_name,
        :title,
        :start_date_month,
        :start_date_year,
        :end_date_month,
        :end_date_year,
        :_method,
        :authenticity_token,
        :first_name,
        :last_name,
        :phone_number,
        :location,
        :address_line_1,
        :address_line_2,
        :city,
        :state,
        :zipcode,
        :remote_interest,
        :accepts,
        :accepts_date,
        :location,
        :social,
        { :social => [
          :github,
          :personal_site
          ]},
        :files,
        :linkedin_profile_positions_attributes,
        { :linkedin_profile_position => [
            :company_name,
            :title,
            :start_date_month,
            :start_date_year,
            :end_date_month,
            :end_date_year
        ]},
        :linkedin_profile_educations_attributes,
        { :linkedin_profile_education => [
            :school_name,
            :degree,
            :field_of_study,
            :start_date_year,
            :gpa
        ]},
        :employment_sought,
        { :employment_sought => [
        ]},
        :salary_expectations,
        {:salary_expectations => [
        ]},
        { :job_search_stage => [
        ]},
        :signuprole,
        { :signuprole => [
          :talent,
          :employer,
          :recruiter
          ]},
        :employer_hiring_roles,
        { :employer_hiring_roles => [
          :technical,
          :non_technical,
          :recruiter,
          :finance
          ]},
        :accepts,
        :accepts_date,
        :position_interest,
        { :position_interest => [
          :sales,
          :technology,
          :finance
        ]},
        :location_interest_usa,
        { :location_interest_usa => [
          :berkeley,
          :chicago,
          :oakland,
          :san_francisco,
          :san_jose,
          :san_diego,
          :no_loc_pref
        ]},
        :work_authorization_status,
        { :work_authorization_status => [
          :work_auth_no,
          :work_auth_yes
        ]},
        :visa_status,
        { :visa_status => [
          :visa_no,
          :visa_yes
        ]},
        :roles_held,
        { :roles_held => [
          :'Back_End',
          :'Front_End',
          :'Data_Engineer',
          :'Data_Science',
          :'Mobile_Dev',
          :'Design',
          :'Development_Ops',
          :'Full_Stack',
          :'Product_Mgmt',
          :'QA_Engineer',
          :'Tech_Mgmt',
          :'UI_UX'
        ]},
        :skills,
        { :skills => [
          :'Android',
          :'Angular_JS',
          :'Automation_Testing',
          :'AWS',
          :'C',
          :'C++',
          :'C#',
          :'Dev_Ops',
          :'Django',
          :'Go',
          :'Hadoop',
          :'iOS',
          :'Java',
          :'Javascript',
          :'Machine_Learning',
          :'Mongo_DB',
          :'MySQL',
          :'Node.js',
          :'Objective-C',
          :'PHP',
          :'Product_Design',
          :'Product_Management',
          :'Python',
          :'R_lang',
          :'React.js',
          :'Scala',
          :'Swift',
          :'Technology_Management',
          :'UI/UX',
          :'Security',
          :'Ruby',
        ]},
        :roles_interested,
        { :roles_interested => [
          :'Back_End_Engineer',
          :'Data_Engineer',
          :'Data_Science',
          :'Design',
          :'DevOps/Infra',
          :'Front_End_Engineer',
          :'Full_Stack_Engineer',
          :'Mobile_Engineer',
          :'Product_Management',
          :'QA_Engineer',
          :'Technology_Management'
        ]},
        :experience_years,
        { :experience_years => [
          :zero_plus,
          :one_plus,
          :two_plus,
          :four_five,
          :four_plus
        ]},
        :user,
        { :user => [
          :roles_held,
          { :roles_held => [
            :'Back_End',
            :'Front_End',
            :'Data_Engineer',
            :'Data_Science',
            :'Mobile_Dev',
            :'Design',
            :'Dev_Ops',
            :'Full_Stack',
            :'Product_Mgmt',
            :'QA_Engineer',
            :'Tech_Mgmt',
            :'UI_UX'
          ]},
          :skills,
          { :skills => [
            :'Android',
            :'Angular_JS',
            :'Automation_Testing',
            :'AWS',
            :'C',
            :'C++',
            :'C#',
            :'Dev_Ops',
            :'Django',
            :'Go',
            :'Hadoop',
            :'iOS',
            :'Java',
            :'Javascript',
            :'Machine_Learning',
            :'Mongo_DB',
            :'MySQL',
            :'Node.js',
            :'Objective-C',
            :'PHP',
            :'Product_Design',
            :'Product_Management',
            :'Python',
            :'R_lang',
            :'React.js',
            :'Scala',
            :'Swift',
            :'Technology_Management',
            :'UI/UX',
            :'Security',
            :'Ruby',
          ]},
          :roles_interested,
          { :roles_interested => [
            :'Back_End_Engineer',
            :'Data_Engineer',
            :'Data_Science',
            :'Design',
            :'DevOps/Infra',
            :'Front_End_Engineer',
            :'Full_Stack_Engineer',
            :'Mobile_Engineer',
            :'Product_Management',
            :'QA_Engineer',
            :'Technology_Management'
          ]},
          :experience_years,
          { :experience_years => [
            :zero_plus,
            :one_plus,
            :two_plus,
            :four_five,
            :four_plus
          ]},
          :first_name,
          :last_name,
          :company_name,
          :title,
          :start_date_month,
          :start_date_year,
          :end_date_month,
          :end_date_year,
          :phone_number,
          :location,
          :linkedin_profile_positions_attributes,
          { :linkedin_profile_position => [
            :company_name,
            :title,
            :start_date_month,
            :start_date_year,
            :end_date_month,
            :end_date_year
          ]},
          :linkedin_profile_educations_attributes,
          { :linkedin_profile_education => [
            :school_name,
            :degree,
            :field_of_study,
            :start_date_year,
            :gpa
          ]},
          :referred_from,
          { :referred_from => [
            :linkedin_site,
            :facebook_site,
            :googleSearch_site,
            :instagram_site,
            :referral_site,
            :other_site
          ]},
          :employment_sought,
          { :employment_sought => [
            :permanent,
            :remote,
            :contract,
            :no_pref
          ]},
          :salary_expectations,
          { :salary_expectations => [
          ]},
          { :job_search_stage => [
            :actively,
            :inactive,
            :passive,
            :interview
          ]},
          :remote_interest,
          :accepts,
          :accepts_date,
          :location,
          :signuprole,
          { :signuprole => [
            :talent,
            :employer,
            :recruiter
            ]},
          :employer_hiring_roles,
          { :employer_hiring_roles => [
            :technical,
            :non_technical,
            :recruiter,
            :finance
            ]},
          :accepts,
          :accepts_date,
          :position_interest,
          { :position_interest => [
            :sales,
            :technology,
            :finance
          ]},
          :location_interest_usa,
          { :location_interest_usa => [
            :berkeley,
            :chicago,
            :oakland,
            :san_francisco,
            :san_jose,
            :san_diego,
            :no_loc_pref
          ]},
          :work_authorization_status,
          { :work_authorization_status => [
            :work_auth_no,
            :work_auth_yes
          ]},
          :visa_status,
          { :visa_status => [
            :visa_no,
            :visa_yes
          ]},
        ]},
        :commit
      ]
      params.permit(accessible)
    end
end

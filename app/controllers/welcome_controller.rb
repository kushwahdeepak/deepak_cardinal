class WelcomeController < ApplicationController
  respond_to :html, :js

  def employer
    if current_user
      after_sign_in
    else
      render 'employer'
    end
  end

  def home
    if current_user
      role_redirection
    else
      render 'talent'
    end
  end

  def home_alt
    @use_alt_page = true
    render 'talent'
  end

  def talent_home
    person = Person.find_by(email_address: current_user&.email)
    @has_resume = person.try(:resume).try(:attached?) || person.try(:resume_text).present?
    @applied_all_jobs_last_30_days = person&.applied_all_jobs_last_30_days?
    @applied_jobs_count = person.submissions.includes(:user).count if person.present?
    @last_applied_to_all_date = person&.applied_to_all_jobs
    @resume = nil
    if person.try(:resume).try(:attached?)
      @resume = person.resume.blob
    end
    render 'home'
  end

  def recruiter
  end


  def on_demand_recruiter
  end
  def refer_for_rewards
  end

  def about_us
    @description = DynamicPageContent.find_by_name('aboutUs')&.content
  end

  def careers
    @jobs = Job.searialize(organization_id: '738a0fe4-983b-41a1-92ee-e0b0c0824449')
  end

  def company_careers
  end
  
  def admin_dashboard
    @information = Admins::AdminInfornationService.new.call
    @data = Admins::AdminInfoForGraphService.new.call
    render 'admin_dashboard'
  end

  def organizations_management
  end

  def recruiter_management
  end

  def reference_data_management
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end

  def after_sign_in
    if session[:contact_request_id].present?
      redirect_to invite_my_connection_path(id: session[:contact_request_id])

    # Update signup date into referrals table based on referral token
    elsif session[:referral_token].present?
      @referral = Referral.find_by(invitee_code: session[:referral_token])
      failure and return if @referral.blank?

      update_referral_signup
      redirect_to job_path(id: @referral.job_id)

    elsif (session[:invite_friends].present? && session[:job_id].present?) || (session[:apply_job].present? && session[:job_id].present?)
      redirect_to job_path(id: session[:job_id])

    else
      role_redirection
    end
  end

  def failure
    session.delete(:referral_token)
    redirect_to root_path
  end

  def update_referral_signup
    @referral.update(signup_date: Time.now)
  end

  def role_redirection
    if current_user.talent?
      redirect_to '/talent_home'
    elsif current_user.employer? || current_user.recruiter?
      redirect_to '/employer_home'
    elsif current_user.guest?
      redirect_to '/users/edit'
    elsif current_user.admin?
      redirect_to '/admin/dashboard'
    else
      redirect_to '/people_searches/new'
    end
  end

end

class Users::ProfileController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :authenticate_user!
  before_action :set_person, only: [:show, :edit, :update]

  # GET /users/profile/:id
  def show
    @avatar_url = @person.avatar_url
    @experiences = @person.job_experiences.order(start_date: :desc) rescue []
    @skills = @person.skills.split(',') rescue []
  end

  # GET /users/:id/edit
  def edit; end

  # PUT /users/profile/:id
  def update;
   begin
     real_params = person_params.to_hash.transform_keys { |k| k.to_sym }.compact
     real_params[:user] = current_user

     @person.update(real_params)
     job_exp_arr = JSON.parse(params['person']['experiences']) rescue []
     job_exp_arr.each do |params|
       job_exp = JobExperience.find(params['id']) rescue nil
       JobExperience.create(params.merge({person_id: @person.id})) if job_exp.nil?
       job_exp.update(params) unless job_exp.nil?
     end
     
     remove_exp_ids=JSON.parse(params['person']['remove_exp_id']) rescue []
     remove_exp_ids.each do |id|
      remove_job_exp=JobExperience.find(id) rescue nil
      remove_job_exp.destroy() unless remove_job_exp.nil?
     end
    
     # update avatar_url column with latest avatar url 
     @person.update_columns(avatar_url: @person.avatar.service_url) if @person.avatar.attached?
     Rails.cache.write("avatar_url_#{@person.id}", @person.avatar.service_url) if @person.avatar.attached?
   rescue ActiveRecord::StatementInvalid  => e
     render plain: "You either didn\'t enter email address in the form, or it already exists in the system. #{e.message}", status: 400
   else
     respond_to do |format|
       format.html { render :show }
       format.json { render json: {updatedPerson: @person.to_filtered_hash, message: 'Update successful.'} }
     end
   end
  end

  def set_person
    @person = Person.includes(:job_experiences).find_by(user_id: params[:id])
    if @person.nil?
      Sentry.capture_message("UserProfileNotRendered::no person record found for user_id: #{params[:id]}") 
      raise(ActiveRecord::RecordNotFound)
    end
  end

  # private
  
  def person_params
    params[:person][:links] = (JSON.parse(params.dig(:person, :links)) || []) if params.dig(:person, :links).class.to_s == 'String'
    params.require(:person)
    .permit(
      :id,
      :first_name,
      :last_name,
      :skills,
      :location,
      :employer,
      :school,
      :company_position,
      :email_address,
      :avatar,
      :company_names,
      :title,
      :description,
      :resume,
    )
  end

  def job_experience_params(person)
    params['person']['experiences'] = JSON.parse(params['person']['experiences']).map {|h| h.merge(person_id: person.id)}
  end
end
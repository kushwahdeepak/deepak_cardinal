class JobExperiencesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_person

  def index
    @experience = JobExperience.all
  end

  def create
    resource = JobExperience.new(job_experience_params)
    if resource.save!
      render json: {success: true, msg: 'job experience saved', job_experience: resource}
      return
    end
    render json: {success: false, msg: 'not able to create job experience', error: resource.errors.messages} and return
  end

  # GET /job_experiences/delete/:id
  def delete_job_experience
    if @job_experience.destroy
      render json: {success: true, messageType: 'success', msg: 'job experience deleted successfully'}
      return
    end
    render json: {success: false, messageType: 'failure', msg: 'job experience not deleted..'}
  end

  def set_person
    @job_experience = JobExperience.find(params[:id]) if params[:id].present?
  end

  private

  def job_experience_params
    params.require(:person).permit(
      :person_id,
      :title,
      :details,
      :start_date,
      :end_date
    )
  end

  def record_not_found
    render json: {success: false, msg: 'Not able to save job experience, Person not found'}
    return
  end
end

class MatchScoresController < ApplicationController
  before_action :authenticate_user!, only: [:from_resume, :matched_jobs]

  def create
    render json: { received: true }, status: 200
    GenerateScoresJob.perform_later match_score_params
  end

  def from_resume_anon
    match_score_result = MatchScoreByResume.new(resume: params[:file])
    match_score_result.call

    render json: { message: 'Success', email: match_score_result.email }, status: :ok
  end

  def from_resume
    match_score_result = MatchScoreByResume.new(current_user: current_user, resume: params[:resume])
    match_score_result.call

    render json: { message: 'Success', email: match_score_result.email }, status: :ok
  end

  # GET /match_scores/talent/:id
  def matched_jobs
    required_fields = [:id, :job_id, :person_id, :name, :score, :numberofopenings, :description, :organization_id, :pref_skills, :gen_reqs, :benefits, :company_names, :school_names, :experience_years]
    person = Person.find_by(user_id: params[:id])
    if person.present?
      top_matched_jobs = Job.top_matched_jobs(person.id).select(required_fields)
      return render json: {success: true, msg: 'matched jobs found', data: top_matched_jobs}, status: 200
    end
    render json: {success: false, msg: 'No matched jobs found', data: []}, status: 200
  end

  private

  def match_score_params
    params.require(:match_score).permit(:job_id, :person_id)
  end
end

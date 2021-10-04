class ResumeGradesController < ApplicationController

  def index
    @resume_grades = ResumeGrade.joins(:job, :person).where("resume_grade IS NULL")
    render json: @resume_grades.map { |resume_grade| { job: resume_grade.job, resume: resume_grade.person.resume.service_url } }
  end

  def create
    @resume_grade = ResumeGrade.new(resume_grade_params)
    if @resume_grade.save
      render json: @resume_grade
    else
      render json: { message: @resume_grade.error.full_messages }
    end
  end

  def retrieve_all_grades
    @ml_data = ResumeGrade.where("resume_grade IS Not NULL")
    render json: @ml_data.map { |ml_data| { id: ml_data.id, resume_grade: ml_data.resume_grade } }
  end

  private

  def resume_grade_params
    params.require(:resume_grade).permit(:job_id, :person_id, :resume_grade)
  end
end

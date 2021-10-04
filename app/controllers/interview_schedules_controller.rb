class InterviewSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :interview, only: [:update]

  # GET /interview_schedules
  def index
    per_page = InterviewSchedule::PER_PAGE
    interview_schedules = InterviewSchedule.extract(page: params[:page], per_page: per_page, month:params[:month], user: params[:interviewers_id],
                                                    own_interview: params[:show_my_interview_only], keyword: params[:keyword])

    render json: {success: true, msg: 'success', messageType: 'success', data: interview_schedules}
  end

  def show
    @interview_schedule = InterviewSchedule.by_interviewer(current_user.id)
    @candidate_name = @interview_schedule.person.name
    render json: {interview_schedule: @interview_schedule}
  end

  def create
    status = check_candidate_interview_status
    if status.present?
      render json: {success: true, msg: "Sorry! Interview Already Present in stage #{status[0].interview_type} For This Job. Please Reschedule !", messageType: 'success', interview_schedule_list: status}, status: :ok
    else
      @error = add_schedule_interview
      unless @error.present?
        job_stage_status_create
        @interview_schedule.send_emails_to_candidate(params[:interview_schedule][:interview_time])
        @interview_schedule.send_emails_to_recruiter
        render json: {success: true, msg: 'Interview Scheduled Successfully And Mail Has Been Send', messageType: 'success', interview_schedule: @interview_schedule, interview_schedule_list: @interview_schedule_list}, status: :ok
      else
        render json: {success: false, msg: @error, messageType: 'failure'}
      end
    end
  end

  def update
    if @interview_schedule.update(interview_schedule_params)
      job_stage_status_create
      @interview_schedule.reschedule_email_to_candidate(params[:interview_schedule][:interview_time])
      @interview_schedule.reschedule_email_to_recruiter
      render json: {success: true, msg: 'Interview Reschedule Successfully And Mail Has Been Send', messageType: 'success', interview_schedule: @interview_schedule}, status: :ok
    else
      render json: {success: false, msg: @interview_schedule.errors.full_messages, messageType: 'failure', error_message: @interview_schedule.errors.full_messages}
    end
  end

  def cancel
    interview = InterviewSchedule.find(params[:interview_schedule_id])
    if interview.cancel()
      interview.send_cancel_email_to_candidate
      interview.send_cancel_email_to_recruiter
      render json: {success: true, msg: 'Interview Cancelled And Mail Has Been Send', messageType: 'success'}, status: :ok
    end
  end

  def scheduled_interviews
    # @user = current_user
    # @person_id = @user.id
    # @user_id=current_user.id
    # @user_name=current_user.name
    @current_user_organization_jobs = current_user&.organization&.jobs&.where(active: true)
    render "interviews/scheduled_interviews"
  end

  def job_stage_status_create
    person_id = @interview_schedule.person_id
    job_id = @interview_schedule.job_id
    stage = @interview_schedule.interview_type
    user_id = current_user.id
    submission = Submission.find_by(person_id: person_id, job_id: job_id)
    submission = Submission.create(user_id: user_id, person_id: person_id, job_id: job_id) if !submission.present?
    stage = StageTransition.create(feedback: "Test", submission_id: submission.id, stage: stage) if submission.present?
    JobStageStatus.stage_count(job_id, user_id, submission) if stage.present?
    GenerateScoresJob.perform_now({ job_id: job_id, person_id: person_id }) 
  end

  private

  def check_candidate_interview_status
     InterviewSchedule.where(organization_id:current_user.organization.id, person_id:params[:interview_schedule][:person_id], job_id:params[:interview_schedule][:job_id])
  end

  def add_schedule_interview
    @interview_schedule_list = []
    error = ""
    params[:interview_schedule][:interview_type] = convert_into_array(params[:interview_schedule][:interview_type])
    interviewer_ids = convert_into_array(params[:interview_schedule][:interviewer_ids])
    params[:interview_schedule][:interview_time] = JSON.parse(params[:interview_schedule][:interview_time])
    ActiveRecord::Base.transaction do
      $i = 0
      $num = params[:interview_schedule][:interview_type].count
      while $i < $num  do
        @interview_schedule = InterviewSchedule.new(interview_schedule_params)
        @interview_schedule.interview_type = params[:interview_schedule][:interview_type][$i]
        @interview_schedule.interviewer_ids = interviewer_ids
        @interview_schedule.interview_time = [params[:interview_schedule][:interview_time][$i]].to_json
        @interview_schedule_list << @interview_schedule
        unless @interview_schedule.save
          error = @interview_schedule.errors.full_messages
          raise ActiveRecord::Rollback
        end
        $i +=1
      end
    end
    error
  end

  def interview
    @interview_schedule = InterviewSchedule.find(params[:id])
  end

  def interview_schedule_params
    params[:interview_schedule][:interviewer_ids] = convert_into_array(params[:interview_schedule][:interviewer_ids])
    params[:interview_schedule][:scheduler_id] = current_user.id.to_s
    params[:interview_schedule][:organization_id] = current_user.organization.id

    params
    .require(:interview_schedule)
    .permit(
      :person_id,
      :description,
      :job_id,
      :interview_date,
      :send_email,
      :send_invite_link,
      :interview_time,
      :interviewers,
      :interview_type,
      :scheduler_id,
      :feedback,
      :organization_id,
      interviewer_ids: []
    )
  end

  def convert_into_array(var)
    if  var.is_a? Array
      [] << var
    else
      var.split(',')
    end
  end

end

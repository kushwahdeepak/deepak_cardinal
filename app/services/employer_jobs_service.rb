class EmployerJobsService
  attr_reader :jobs, :jobs_data

  def initialize(current_user, params, own_jobs: params[:own_jobs], closed_jobs: params[:closed_jobs])
    @jobs = []
    @current_user = current_user
    @page = params[:page] || 1
    @keyword = params[:keyword] || ''
    @job_keyword = params[:job_keyword] || ''
    @own_jobs = own_jobs
    @closed_jobs = closed_jobs 
    @date_range = if params[:start_date].present? && params[:end_date].present? then (Date::strptime(params[:start_date], '%m/%d/%Y')..Date::strptime(params[:end_date], '%m/%d/%Y')) else nil end
    @job = Job.find_by(id: params[:job_id])
  end

  def call
    retrieve_jobs
    jobs_response
  end

  def jobs_response
      total_count = @job.present? ? @jobs.count : @jobs.total_entries
      @jobs_data = {
        jobs_total_count: total_count,
        jobsCount: total_count,
        total_pages: if @job.present? then 1 else @jobs.total_pages end,
        jobs: @jobs.map { |job| job.to_hash.merge({ metrics: get_metrics_data(job) }) }
      }
  end

  private

  def get_metrics_data(job)
    if @current_user.present?
      stage = JobStageStatus.where(job_id: job.id)
    else
      stage = []
    end
  end

  def retrieve_jobs
   
    job_search_params = { user: @current_user }
    job_search_params.merge!(keyword: @keyword) if @keyword.present?
    job_search_params.merge!(job_keyword: @job_keyword) if @job_keyword.present?
    job_search = JobSearch.create(job_search_params)
    @jobs = if @job.present? then [@job] else job_search.query_search_engine_get_jobs(page: @page, per_page: 20, own_jobs: @own_jobs, closed_jobs: @closed_jobs) end
  end

  def submission_metrics(job, latest_date = DateTime.now.to_date + 1.day)
    stage_transitions = StageTransition.by_submissions(job.submissions.ids, latest_date).to_json
    stage_transitions_hash = JSON.parse(stage_transitions) || {}

    {
      leads_count:            job.employer_dashboard&.leads,
      applicants_count:       applicants_count_for_stage(stage_transitions_hash, StageTransition::APPLICANTS),
      submitted:              applicants_count_for_stage(stage_transitions_hash, StageTransition::SUBMITTED),
      first_interview_count:  applicants_count_for_stage(stage_transitions_hash, StageTransition::FIRST_INTERVIEW),
      second_interview_count: applicants_count_for_stage(stage_transitions_hash, StageTransition::SECOND_INTERVIEW),
      recruitor_screen:       applicants_count_for_stage(stage_transitions_hash, StageTransition::RECRUITOR_SCREEN),
      offers_count:           applicants_count_for_stage(stage_transitions_hash, StageTransition::OFFER),
      archive_count:          applicants_count_for_stage(stage_transitions_hash, StageTransition::REJECT),
      metrics_date:           latest_date.to_s
    }
  end

  def applicants_count_for_stage(stage_transition, stage)
    stage_transition.filter{|st| st['stage'] == stage}.count
  end
end

class UpdateEmployerDashboardService
  attr_reader :job, :submissions, :employer_dashboard

  def initialize(job)
    @job = job
    @employer_dashboard = job&.employer_dashboard
    @submissions = @job&.submissions
  end

  def call
    update_employer_dashboard
  end

  private

  def update_employer_dashboard
    return create_dashboard unless employer_dashboard.present?
    employer_dashboard.update(find_stage_submissions_for_job)
  end

  def create_dashboard
    stage_params = find_stage_submissions_for_job
    params = {}
    params[:job_id] = job.id
    params[:organization_id] = job&.organization_id
    params[:leads] = Job.jobs_lead_metrics(job&.user&.id, job.id)
    params[:applicant] = stage_params[:applicant]

    puts "Creating employer dashboard record for job: #{job.name} #{job.id}"

    EmployerDashboard.create(params)
  end

  def find_stage_submissions_for_job
    params = {}
    @submissions.each do |submission|
      stage = submission&.stage_transitions&.last&.stage
      key = stage&.to_sym
      params[key].present? ? params[key] += 1 : params[key] = 0
    end

    params
  end
end

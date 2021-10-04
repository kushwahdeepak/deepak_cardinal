class ApplyToAllMatchingJobsService
  include IncomingMailsHelper
  include SubmissionEmailHelper

  TOP_MATCHING_JOBS_SIZE = 8.freeze

  def initialize(person, current_user)
    @person = person
    @current_user = current_user
  end

  def call
    if @person.applied_all_jobs_last_30_days?
      Rails.logger.info("person #{@person.email_address} has applied to all jobs within last 30 days")
    else
      top_matching_job_ids.each do |job_id|
        existing_submission = Submission.find_by(job_id: job_id, user: @current_user, person: @person)
        submission = create_submission(job_id) unless existing_submission.present?
        send_mails_about_appliying_to_a_job(submission: existing_submission || submission)
      end
      @person.update(applied_to_all_jobs: DateTime.now)
    end
  end

  private

  def top_matching_job_ids
    score_value = SystemConfiguration.find_by(name: Job::SCORE_NAME).value
    Job.top_matched_jobs(@person.id, score: score_value)
       .limit(TOP_MATCHING_JOBS_SIZE)
       .pluck(:id)
  end

  def create_submission(job_id)
    Submission.create!(
      job_id: job_id, user: @current_user,
      person: @person
    ).tap do |submission|
      Note.create!(user: submission.user, body: submission.to_s, person: @person)
    end
  end

  # def person
  #   @person ||= Person.find_by(email_address: @person&.email_address)
  # end
end

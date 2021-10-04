#represents the connection between a job and a candidate such as submission (recruiter submits candidate to a job),
# application (candidate submits self to a job), invitation to interveiw (job owner submits self to candiate).
# The candidate is represented by pperson member, the recruiter by user and job by job.
class SubmissionValidator < ActiveModel::Validator
  def validate(record)
    #if we get a job id, it needs to have a record associated with it.
    if record.job_id.present? and not Job.find_by_id record.job_id
      record.errors[:base] << "Job with id #{record.job_id} doesn't exist"
    end
    #same with the person
    if record.person_id.present? and not Person.find_by_id record.person_id
      record.errors[:base] << "Person with id #{record.person_id} doesn't exist"
    end
    #we must have exactly one creator
    # creator_violation = !(record.user.present? ^ record.incoming_mail.present?)
    # record.errors[:base] << "Submission must be created by exactly one: user xor incomming_mail" if creator_violation
  end
end


class Submission < ApplicationRecord
  LEAD = "lead".freeze
  TYPES = [LEAD].freeze

  validates_with SubmissionValidator
  belongs_to :user, optional: true                    #recruiter that submitted the candidate if applies
  belongs_to :person , optional: true                 # the candidate
  belongs_to :job, optional: true                     #job applied to
  belongs_to :incoming_mail, optional: true           #the email from linked in notifying that submitted.
  has_many   :stage_transitions, dependent: :destroy
  validates :submission_type, inclusion: { in: TYPES, allow_nil: true }

  # Scope
  scope :pluck_submissions_id, -> (jobs_id) { where(job_id: jobs_id).pluck(:id) }

  after_save :reindex_candidate_for_submission
  after_destroy :regenerate_stage_count

  def reindex_candidate_for_submission
    candidate = SubmittedCandidateInfo.find_by(candidate_id: self.person_id, job_id: self.job_id)
    candidate&.__elasticsearch__&.index_document
  end

  def regenerate_stage_count
    JobStageStatus.stage_count(self.job_id, self.user_id, self)
  end

  def to_s
    if incoming_mail.present? #if submission was created by incoming_mail
      job_desc = job.present? ?  "#{job.name}(id: #{job.id})" : "unknown"
      person_desc = person&.email_address||"unknown"
      "Candidate #{person_desc} was submitted to the job #{job_desc} through linkedin (incoming_mail id:#{incoming_mail.id}) on #{created_at.to_date}"
    else #or was it created by a recruiter using ui
      "Candidate #{person&.email_address} was submitted to the job #{job&.name}(id: #{job&.id}) by #{user&.email || person&.email_address}) on #{created_at&.to_date}"
    end
  end

  def self.find_by_person_and_job person_id, job_id
    Submission.find_by_sql("select * from submissions where person_id=#{person_id} and job_id=#{job_id} order by created_at").last
  end

  def self.submitted_candidates(job)
    submitted_candidate_ids = job.submissions.joins(:person).pluck(:person_id)
    Person.where(id: submitted_candidate_ids)
  end

  def self.create_submission(current_user, submission_params)
    person = Person.find_by(email_address: current_user&.email)
    job = Job.find(submission_params[:job_id])
    prepare_submission_params(current_user, person, job, submission_params)
    if Submission.find_by(job_id: job.id, user_id: submission_params[:user_id], person_id: submission_params[:person_id]).present?
      "You've already applied for this job before"
    else
      submission = Submission.new(submission_params)
      return submission.errors.full_messages.join(' ') unless submission.save

      Note.create!(user: submission.user, body: submission.to_s, person: submission.person)
      return submission
    end
  rescue Exception => error
    error.to_s
  end

  def self.prepare_submission_params(current_user, person, job, submission_params)
    if current_user.talent? || current_user.admin?
      submission_params[:person_id] = person&.id
      submission_params[:user_id] = current_user.id
      submission_params[:submission_type] = nil
    else
      submission_params[:user_id] = current_user.id
    end
  end

  def change_stage(feedback:, stage: nil)
    # stagetransition = stage_transitions.find_by(submission_id: self.id)
    StageTransition.create!(submission: self, feedback: feedback, stage: stage)
    interveiw = InterviewSchedule.where(person_id:self.person_id, job_id:self.job_id, scheduler_id:self.user_id)
    interveiw.update(interview_type: stage) if interveiw.present?
    JobStageStatus.stage_count(self.job_id, self.user_id, self)
  end

  # def get_stage
  #   return nil if stage_transitions.empty?

  #   stage_transitions.where.not(stage: StageTransition::REJECT).order(created_at: :desc).first
  # end

  # private

  # def next_stage(stage)
  #   return stage if stage.present?
  #   current_stage = get_stage.try(:stage)
  #   if current_stage.present?
  #     index = StageTransition::STAGES.index(current_stage)
  #     StageTransition::STAGES[index + 1] == StageTransition::REJECT ? StageTransition::STAGES[index] : StageTransition::STAGES[index + 1]
  #   else
  #     StageTransition::STAGES.first
  #   end
  # end
end

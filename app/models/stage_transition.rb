class StageTransition < ApplicationRecord

  include EsSearchable
  after_save :reindex_stage_transtions
  LEAD = 'lead'.freeze
  SUBMITTED = 'submitted'.freeze
  FIRST_INTERVIEW = 'first_interview'.freeze
  SECOND_INTERVIEW = 'second_interview'.freeze
  OFFER = 'offer'.freeze
  REJECT = 'reject'.freeze
  APPLICANTS = 'applicant'.freeze
  RECRUITOR_SCREEN = 'recruitor_screen'.freeze
  STAGES = [ LEAD, APPLICANTS, SUBMITTED, FIRST_INTERVIEW, SECOND_INTERVIEW, OFFER, REJECT, RECRUITOR_SCREEN ].freeze

  # Scope
  scope :by_submissions, -> (ids, latest_date = DateTime.now.to_date + 1.day) { where("id in (SELECT MAX(id) as id FROM stage_transitions WHERE submission_id in (#{if ids.empty? then 'NULL' else ids.join(',') end}) AND created_at <= '#{latest_date}' GROUP BY submission_id)").select(:submission_id, :stage) }

  belongs_to :submission

  validates :stage, presence: true, inclusion: { in: STAGES }

  private

  def reindex_stage_transtions
    candidate = SubmittedCandidateInfo.find_by(submission_id: self.submission_id, job_id: self.submission.job_id) 
    candidate&.__elasticsearch__&.index_document
  end
end


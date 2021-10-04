class MatchScore < ApplicationRecord
  LEADS_MINIMUM_SCORE = 25.0.freeze
  LEADS_MAXIMUM_SCORE = 100.0.freeze

  after_save :reindex_match_score

  belongs_to :person
  belongs_to :job

  attribute :score, :float, default: 0.0

  validates_presence_of :person_id, :job_id, :score

  private

  def reindex_match_score
    candidate = SubmittedCandidateInfo.find_by(candidate_id: self.person_id, job_id: self.job_id)
    candidate&.__elasticsearch__&.index_document
  end
end

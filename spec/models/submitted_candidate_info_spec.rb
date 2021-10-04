require 'rails_helper'

RSpec.describe SubmittedCandidateInfo, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:job) }
    it { is_expected.to belong_to(:submission) }
  end

  describe '.recreate_sql' do
    let(:user) { create(:user) }
    let(:job1) { create(:job) }
    let(:job2) { create(:job) }
    let(:job3) { create(:job) }
    let(:p1) { create(:person, location: 'San Francisco', top_school: true, email_address: SecureRandom.uuid, user: user, organization: nil) }
    let(:p2) { create(:person, location: 'San Jose', email_address: SecureRandom.uuid, user: user, organization: nil) }
    let!(:submission1) { create(:submission, job: job1, user: user, person: p1) }
    let!(:submission2) { create(:submission, job: job2, user: user, person: p1) }
    let!(:submission3) { create(:submission, job: job2, user: user, person: p2) }
    let!(:submission4) { create(:submission, job: job3, user: user, person: p2) }
    let!(:match_score1) { create(:match_score, score: 40.0, job: job1, person: p1) }
    let!(:match_score2) { create(:match_score, score: 15.0, job: job2, person: p1) }
    let!(:match_score3) { create(:match_score, score: 16.0, job: job2, person: p2) }
    let!(:match_score4) { create(:match_score, score: 50.0, job: job3, person: p2) }

    it 'returns submitted candiate info correctly after recreate sql' do
      expect(described_class.count).to eq(4)
      expect(SubmittedCandidateInfo.find_by(job_id: job2.id, id: p2.id).match_score).to eq 16.0
    end
  end

  describe 'current_stage' do
    let(:user) { create(:user) }
    let(:job1) { create(:job) }
    let(:job2) { create(:job) }
    let(:job3) { create(:job) }
    let(:p1) { create(:person, location: 'San Francisco', top_school: true, email_address: SecureRandom.uuid, user: user, organization: nil) }
    let(:p2) { create(:person, location: 'San Jose', email_address: SecureRandom.uuid, user: user, organization: nil) }
    let!(:submission1) { create(:submission, job: job1,  person: p1) }
    let!(:submission2) { create(:submission, job: job2,  person: p1) }
    let!(:submission3) { create(:submission, job: job2,  person: p2) }
    let!(:submission4) { create(:submission, job: job3,  person: p2) }
    let!(:match_score1) { create(:match_score, score: 40.0, job: job1, person: p1) }
    let!(:match_score2) { create(:match_score, score: 15.0, job: job2, person: p1) }
    let!(:match_score3) { create(:match_score, score: 16.0, job: job2, person: p2) }
    let!(:match_score4) { create(:match_score, score: 50.0, job: job3, person: p2) }
    let!(:stage_transition1) { create(:stage_transition, :lead, submission_id: submission1.id ) }
    let!(:stage_transition2) { create(:stage_transition, :first_interview, submission_id: submission1.id ) }
    let!(:stage_transition3) { create(:stage_transition, :lead, submission_id: submission2.id ) }
    let!(:stage_transition4) { create(:stage_transition, :lead, submission_id: submission3.id ) }
    let!(:stage_transition5) { create(:stage_transition, :first_interview, submission_id: submission3.id ) }
    let!(:stage_transition6) { create(:stage_transition, :offer, submission_id: submission3.id ) }
    it 'return last stage for person 1' do
      expect(SubmittedCandidateInfo.find_by(job_id: job1.id, submission_id: submission1.id).candidate_stage).to eq 'first_interview'
    end
    it 'returns submitted candiate info whose stage is lead' do
      expect(SubmittedCandidateInfo.find_by(job_id: job2.id, submission_id: submission2.id).candidate_stage).to eq 'lead'
    end
    it 'returns submitted candiate info whose stage is offer' do
      expect(SubmittedCandidateInfo.find_by(job_id: job2.id, submission_id: submission3.id).candidate_stage).to eq 'offer'
    end
  end
end

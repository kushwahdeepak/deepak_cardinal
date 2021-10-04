require 'rails_helper'

describe ApplyToAllMatchingJobsService do
  subject { described_class.new(current_user).call }

  let(:not_matching_jobs) { create_list(:job, 5) }
  let(:matching_jobs) { create_list(:job, 5) }

  before do
    matching_jobs.each do |matching_job|
      create(
        :match_score, person: person,
        job: matching_job, score: rand(50..90)
      )
    end

    not_matching_jobs.each do |not_matching_job|
      create(
        :match_score, person: person,
        job: not_matching_job, score: rand(0..49)
      )
    end
  end

  let(:person) { create(:person, user: current_user) }
  let(:current_user) { create(:user, :candidate) }

  it 'should create submission for all matching jobs' do
    expect {
      subject
    }.to change { Submission.count }.from(0).to(matching_jobs.count)

    Submission.all.each do |submission|
      expect(submission.person_id).to eql(person.id)
      expect(submission.user_id).to eql(current_user.id)
      expect(matching_jobs.pluck(:id)).to include(submission.job_id)
      expect(not_matching_jobs.pluck(:id)).not_to include(submission.job_id)
    end
  end
end


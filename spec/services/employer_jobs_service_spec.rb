require 'rails_helper'

describe EmployerJobsService do
  subject { described_class.new(current_user, params, own_jobs: false).call }

  let(:current_user) { create(:user, :employer) }
  let(:candidate_user) { create(:user, :candidate) }
  let(:candidate) { create(:person, user: candidate_user) }
  let(:first_job) { create(:job, user: current_user, portalcompanyname: 'Ololo', skills: 'Assembler') }
  let(:second_job) { create(:job, user: current_user, portalcompanyname: 'Ololo') }

  # Submissions at applicant stage
  let(:applicant_submission_one) { create(:submission, user: current_user, person: candidate, job: first_job) }
  let(:applicant_submission_two) { create(:submission, user: current_user, person: candidate, job: first_job) }

  let(:applicant_submission_three) { create(:submission, user: current_user, person: candidate, job: second_job) }

  # Submissions at first_interview stage
  let(:first_interview_submission_one) { create(:submission, user: current_user, person: candidate, job: first_job) }
  let(:first_interview_submission_two) { create(:submission, user: current_user, person: candidate, job: first_job) }

  # One submissions at second_interview stage
  let(:second_interview_submission_one) { create(:submission, user: current_user, person: candidate, job: first_job) }

  let(:second_interview_submission_two) { create(:submission, user: current_user, person: candidate, job: second_job) }

  # One submission at offer stage
  let(:offer_submission) { create(:submission, user: current_user, person: candidate, job: first_job) }

  before do
    Sunspot.remove_all!
    # Create stage transitions for submissions which are both at applicant stage
    create_applicant_stage_transitions(applicant_submission_one)
    create_applicant_stage_transitions(applicant_submission_two)

    create_applicant_stage_transitions(applicant_submission_three)

    # Create stage transitions for the submission being at first_interview_submission stage
    create_first_interview_stage_transitions(first_interview_submission_one)
    create_first_interview_stage_transitions(first_interview_submission_two)
    # Create stage transitions for the submission that is at second_interview stage
    create_second_interview_stage_transitions(second_interview_submission_one)

    create_second_interview_stage_transitions(second_interview_submission_two)
    # Create stage transitions for the submission that is at offer stage
    create_offer_stage_transitions(offer_submission)

    create_list(:job, 40, user: current_user)
    create_list(:user, 30, :candidate)

    User.where(role: 4).each { |candidate_user|  create(:person, user: candidate_user) unless Person.find_by_email(candidate_user.email).present? }
    Person.first(7).each do |candidate_person|
      candidate_person.update!(skills: 'abc', organization_id: nil)
      create(:match_score, job: first_job, person: candidate_person, score: rand(25..100).to_f)
    end

    Person.first(10).each do |candidate_person|
      candidate_person.update!(skills: 'abc', organization_id: nil)
      create(:match_score, job: second_job, person: candidate_person, score: rand(25..100).to_f)
    end
  end

  context 'with correct params' do
    let(:jobs_data) { subject }

    context 'without keyword' do
      let(:params) { { page: 1 } }
  
      it 'should return correct count of submissions for each stages' do
        job_first = jobs_data[:jobs].find { |job| job[:id] == first_job.id }
        job_second = jobs_data[:jobs].find { |job| job[:id] == second_job.id }
  
        expect(jobs_data[:jobs_total_count]).to eql(42)
        expect(jobs_data[:jobsCount]).to eql(20)
  
        expect(job_first[:metrics][0][:applicants_count]).to eql(2)
        expect(job_first[:metrics][0][:submitted]).to eql(2)
        expect(job_first[:metrics][0][:first_interview_count]).to eql(2)
        expect(job_first[:metrics][0][:second_interview_count]).to eql(1)
        expect(job_first[:metrics][0][:offers_count]).to eql(1)
        expect(job_first[:metrics][0][:leads_count]).to eql(7)
  
        expect(job_second[:metrics][0][:applicants_count]).to eql(1)
        expect(job_second[:metrics][0][:submitted]).to eql(1)
        expect(job_second[:metrics][0][:first_interview_count]).to eql(0)
        expect(job_second[:metrics][0][:second_interview_count]).to eql(1)
        expect(job_second[:metrics][0][:offers_count]).to eql(0)
        expect(job_second[:metrics][0][:leads_count]).to eql(10)
      end
    end

    context 'with keyword' do
      context 'by company name' do
        let(:params) { { page: 1, keyword: 'Ololo' } }
        
        it 'should return only relevant jobs' do
          expect(jobs_data[:jobs].count).to eql(2)
          expect(jobs_data[:jobs].pluck(:id).sort).to eql([first_job.id, second_job.id].sort)
        end
      end
    end
  end
end

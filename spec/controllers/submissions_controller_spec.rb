require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do

  let(:talent) { create(:user, role: 'guest') }
  let(:employer) { create(:user, role: 'employer') }
  let(:recruiter) { create(:user, role: 'recruiter') }
  let(:talent_role) { create(:user, role: 'talent') }
  let(:job_list) { create_list(:job, 3, user: employer) }
  let(:stage) { StageTransition::SECOND_INTERVIEW }
  let(:feedback) { "This is test feedback" }
  let(:user) { create(:user) }
  let(:person) { create(:person) }
  let(:json_response) { JSON.parse(response.body).deep_symbolize_keys! }

  before { @submission_list = job_list.map { |job| create(:submission, job: job, user: user) } }

  describe '#create' do
    it "create submission with lead type " do
      controller.stub(:current_user) { recruiter }
      put :create, params: { submission: { user_id: recruiter.id, person_id: person.id, job_id: job_list[0].id, submission_type: Submission::LEAD } }
      expect(response.status).to eq 200
      expect(Submission.find_by(id: json_response[:submission][:id]).submission_type).to eq Submission::LEAD
    end

    it "create submission without type " do
      controller.stub(:current_user) { recruiter }
      put :create, params: { submission: { user_id: recruiter.id, person_id: person.id, job_id: job_list[0].id } }
      expect(response.status).to eq 200
      expect(Submission.find_by(id: json_response[:submission][:id]).submission_type).to be_nil
    end

    it "failed submission with wrong type " do
      controller.stub(:current_user) { recruiter }
      put :create, params: { submission: { user_id: recruiter.id, person_id: person.id, job_id: job_list[0].id, submission_type: "other" } }
      expect(response.status).to eq 422
    end
  end

  describe '#change_stage' do
    it 'will be success' do
      controller.stub(:current_user) { recruiter }
      put :change_stage, params: { submission_ids: @submission_list.pluck(:id), feedback: feedback, stage: StageTransition::APPLICANTS }
      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response[:stage_transitions].count).to eql(@submission_list.count)

      json_response[:stage_transitions].each do |stage_transition|
        expect(@submission_list.pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:feedback]).not_to be_nil
        expect(stage_transition[:stage]).to eql(StageTransition::APPLICANTS)
      end
    end

    it 'moving to offer' do
      controller.stub(:current_user) { recruiter }
      put :change_stage, params: { submission_ids: @submission_list.pluck(:id), feedback: feedback, stage: StageTransition::OFFER }
      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response[:stage_transitions].count).to eql(@submission_list.count)

      json_response[:stage_transitions].each do |stage_transition|
        expect(@submission_list.pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:feedback]).not_to be_nil
        expect(stage_transition[:stage]).to eql(StageTransition::OFFER)
      end
    end

    it 'moving to first Interview' do
      controller.stub(:current_user) { recruiter }
      put :change_stage, params: { submission_ids: @submission_list.pluck(:id), feedback: feedback, stage: StageTransition::FIRST_INTERVIEW }
      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response[:stage_transitions].count).to eql(@submission_list.count)

      json_response[:stage_transitions].each do |stage_transition|
        expect(@submission_list.pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:feedback]).not_to be_nil
        expect(stage_transition[:stage]).to eql(StageTransition::FIRST_INTERVIEW)
      end
    end

    it 'moving to first Interview' do
      controller.stub(:current_user) { recruiter }
      put :change_stage, params: { submission_ids: @submission_list.pluck(:id), feedback: feedback, stage: StageTransition::SECOND_INTERVIEW }
      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response[:stage_transitions].count).to eql(@submission_list.count)

      json_response[:stage_transitions].each do |stage_transition|
        expect(@submission_list.pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:feedback]).not_to be_nil
        expect(stage_transition[:stage]).to eql(StageTransition::SECOND_INTERVIEW)
      end
    end

    it 'will be fail' do
      controller.stub(:current_user) { talent }
      expect { put :change_stage, params: { submission_ids: @submission_list.pluck(:id), stage: StageTransition::APPLICANTS } }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe '#reject' do
    before { @submission_list.each { |submission| create(:stage_transition, submission: submission, stage: stage) } }

    it 'reject stage' do
      controller.stub(:current_user) { recruiter }
      put :reject, params: { submission_ids: @submission_list.pluck(:id), feedback: feedback }
      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response[:stage_transitions].count).to eql(@submission_list.count)
      json_response[:stage_transitions].each do |stage_transition|
        expect(@submission_list.pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:feedback]).not_to be_nil
        expect(stage_transition[:stage]).to eql(StageTransition::REJECT)
      end
    end
  end

  describe 'moving from leads to other stages' do

    it 'lead to applicant' do
      controller.stub(:current_user) { recruiter }
      post :move_to_applicant_stage, params: { submissions: [{ user_id: talent_role.id, person_id: person.id, job_id: job_list[0].id }], stage: StageTransition::APPLICANTS, job_id: job_list[0].id }

      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response).to have_key(:submissions)
      expect(json_response[:stage_transitions].count).to eql(1)

      json_response[:stage_transitions].each do |stage_transition|
        expect(json_response[:submissions].pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:stage]).to eql(StageTransition::APPLICANTS)
      end
    end

    it 'lead to First Intrview' do
      controller.stub(:current_user) { recruiter }
      post :move_to_applicant_stage, params: { submissions: [{ user_id: talent_role.id, person_id: person.id, job_id: job_list[0].id }], stage: StageTransition::FIRST_INTERVIEW, job_id: job_list[0].id }

      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response).to have_key(:submissions)
      expect(json_response[:stage_transitions].count).to eql(1)

      json_response[:stage_transitions].each do |stage_transition|
        expect(json_response[:submissions].pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:stage]).to eql(StageTransition::FIRST_INTERVIEW)
      end
    end

    it 'lead to offer' do
      controller.stub(:current_user) { recruiter }
      post :move_to_applicant_stage, params: { submissions: [{ user_id: talent_role.id, person_id: person.id, job_id: job_list[0].id }], stage: StageTransition::OFFER, job_id: job_list[0].id }

      expect(response.status).to eq 200
      expect(json_response).to have_key(:stage_transitions)
      expect(json_response).to have_key(:submissions)
      expect(json_response[:stage_transitions].count).to eql(1)

      json_response[:stage_transitions].each do |stage_transition|
        expect(json_response[:submissions].pluck(:id)).to include(stage_transition[:submission_id])
        expect(stage_transition[:stage]).to eql(StageTransition::OFFER)
      end
    end

  end

  describe 'apply job using referral link' do
    let(:referral) { create(:referral, inviter_id: talent_role.id, job_id: job_list[0].id) }

    it 'update referral job applied date' do
      controller.stub(:current_user) { recruiter }
      expect(referral.job_applied_date).to be_nil

      put :create, params: { submission: { user_id: recruiter.id, person_id: person.id, job_id: job_list[0].id } }, session: { referral_token: referral.invitee_code}

      expect(response.status).to eq 200
      expect(referral.reload.job_applied_date).not_to be_nil
      expect(session[:referral_token]).to be_nil
    end
  end

  describe 'apply job using without referral link' do
    let(:referral) { create(:referral, inviter_id: talent_role.id, job_id: job_list[0].id) }

    it 'apply job' do
      controller.stub(:current_user) { recruiter }
      expect(referral.job_applied_date).to be_nil

      put :create, params: { submission: { user_id: recruiter.id, person_id: person.id, job_id: job_list[0].id } }

      expect(response.status).to eq 200
      expect(referral.reload.job_applied_date).to be_nil
    end
  end

end
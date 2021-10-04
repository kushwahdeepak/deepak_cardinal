require 'rails_helper'

describe 'JobController', type: :request do
  let(:owner) { create(:user, role: :employer) }
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'plain.txt'), 'application/txt') }

  before {  sign_in(owner) }

  describe 'create' do
    let(:params) { { job: { name: 'Test job', description: 'Test', logo: file } } }

    it 'creates job successfully with log attachment' do
      expect {
        post '/jobs', params: params
      }.to change { Job.count }.by(1)

      expect(Job.last.logo.attached?).to be true
    end
  end

  describe 'show' do
    let(:payload) { OpenStruct.new(payload: OpenStruct.new(parsed_response: { "email_address" => owner.email })) }
    let(:new_job) { Job.create!({ name: 'Test job', description: 'Test', logo: file }) }
    let(:referral) { create(:referral, inviter_id: recruiter.id, job_id: new_job.id) }
    let(:recruiter) { create(:user, role: 'recruiter') }

    before { allow(OutgoingMailService).to receive(:retrieve_email_credentials).and_return(payload) }

    it 'get job successfully' do
      get "/jobs/#{new_job.id}", params: {}, headers: { 'ACCEPT' => 'application/json' }
      job_result = JSON.parse(response.body)['job']
      expect(response.status).to eq 200
      expect(job_result["logo"]).not_to be_nil
    end

    it 'setup referral token when user click referral link' do
      get "/jobs/#{new_job.id}", params: {token: referral.invitee_code}, headers: { 'ACCEPT' => 'application/json' }
      expect(assigns[:show_invite_friends]).to eq false
      expect(session[:referral_token]).not_to be_nil
      expect(session[:referral_token]).to eq referral.invitee_code
    end
  end
end

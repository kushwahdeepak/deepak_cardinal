require 'rails_helper'

describe 'ReferralsController', type: :request do

  let(:talent) { create(:user, role: 'talent') }
  let(:employer) { create(:user, role: 'employer') }
  let(:recruiter) { create(:user, role: 'recruiter') }
  let(:job) { create(:job, creator_id: employer.id) }

  describe 'create referrals for recruiter' do

    before { sign_in(recruiter, scope: :user) }

    it "create referrals" do
      expect{
        post '/referrals', params: { job_id: job.id, message: 'Test',
                                referrals:[ {invitee_name: 'Test 1', invitee_email: 'test1@gmail.com'},
                                            {invitee_name: 'Test 2', invitee_email: 'test2@gmail.com'}
                                          ]
                              }
      }.to change {Referral.count }.by(2)

      expect(response.status).to eq 200
    end
  end

  describe 'create referrals for talent' do

    before { sign_in(talent, scope: :user) }

    it "create referrals" do
      expect{
        post '/referrals', params: { job_id: job.id, message: 'Test',
                                referrals:[ {invitee_name: 'Test 1', invitee_email: 'test1@gmail.com'},
                                            {invitee_name: 'Test 2', invitee_email: 'test2@gmail.com'}
                                          ]
                              }
      }.to change {Referral.count }.by(2)

      expect(response.status).to eq 200
    end
  end

  describe 'Not allowed to create referrals for employer' do
    before { sign_in(employer, scope: :user) }

    it "Not Authorized" do
      expect {

        post '/referrals', params: { job_id: job.id, message: 'Test',
                                   referrals:[ {invitee_name: 'Test 1', invitee_email: 'test1@gmail.com'},
                                               {invitee_name: 'Test 2', invitee_email: 'test2@gmail.com'}
                                             ]
                                  }
      }.to change {Referral.count }.by(0)
    end
  end

end
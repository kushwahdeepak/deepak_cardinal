
require 'rails_helper'

RSpec.describe Referral, type: :model do
  let(:recruiter) { create(:user, role: 'recruiter') }
  let(:employer) { create(:user, role: :employer) }
  let(:job) { create(:job, creator_id: employer.id) }

  describe 'create' do
    let(:referral) { create(:referral, inviter_id: recruiter.id, job: job) }

    it 'creates referral successfully' do
      expect(referral.save).to be_truthy
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:job) }
  end

  describe 'association values' do
    let(:referral) { create(:referral, inviter_id: recruiter.id, job: job) }

    it 'has correct association values' do
      expect(referral.user).to eql(recruiter)
      expect(referral.job).to eql(job)
    end
  end

  describe 'update' do
    let(:referral) { create(:referral, inviter_id: recruiter.id, job: job) }

    it 'updates referral other fields' do
      expect(referral.update(invitation_date: Time.now, email_send_date: Time.now, signup_date: Time.now + 1.day)).to be_truthy
    end

  end

  describe 'destroy' do
    let!(:referral) { create(:referral, inviter_id: recruiter.id, job: job) }

    it 'removes an referral' do
      expect{
        referral.destroy
      }.to change { Referral.count }.from(1).to(0)
    end
  end

  describe 'generate_token' do
    let(:referral) { create(:referral, inviter_id: recruiter.id, job: job) }

    it 'generate uniq token' do
      expect(referral.invitee_code).not_to be_nil
      expect(referral.signup_date).to be_nil
      expect(referral.job_applied_date).to be_nil
    end

    it 'update signup date' do
      expect(referral.signup_date).to be_nil
      expect( Referral.update_signup_date(referral.invitee_code)).not_to be_nil
    end

    it 'update job applied date' do
      expect(referral.job_applied_date).to be_nil
      expect( Referral.update_job_applied_date(referral.invitee_code)).not_to be_nil
    end
  end
end

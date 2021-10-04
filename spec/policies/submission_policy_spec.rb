require 'rails_helper'

RSpec.describe SubmissionPolicy do

  let(:guest) { create(:user, role: 'guest') }
  let(:talent) { create(:user, role: 'talent') }
  let(:employer) { create(:user, role: 'employer') }
  let(:recruiter) { create(:user, role: 'recruiter') }
  let(:admin) { create(:user, role: 'admin') }
  let(:submission) { create(:submission, job: create(:job, user: employer), user: create(:user)) }
  let(:stage_transition) { create(:stage_transition, submission: submission) }

  describe "#SubmissionPolicy" do
    subject { described_class }

    permissions :change_stage?, :reject? do
      it "denies access if user has not employer role" do
        expect(subject).not_to permit(guest, stage_transition)
        expect(subject).not_to permit(talent, stage_transition)
      end

      it "grants access if user has employer role" do
        expect(subject).to permit(recruiter, stage_transition)
        expect(subject).to permit(admin, stage_transition)
      end
    end
  end
end

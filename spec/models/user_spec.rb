require 'rails_helper'
include ActionMailer::TestHelper

RSpec.describe User, type: :model do
  describe 'admins scope' do
    let!(:recruiter) { create(:user) }
    let!(:employee) { create(:user, :employee) }
    let!(:guests) { create_list(:user, 2, :guest) }

    context 'when no admins exist' do
      it 'returns an empty list' do
        expect(User.admins).to be_empty
      end
    end

    context 'when there are admins' do
      let!(:admins) { create_list(:user, 2, :admin) }

      it 'returns admins' do
        returned_admins = User.admins
        expect(returned_admins.size).to eq 2
        expect(returned_admins.ids.sort).to eq(admins.pluck(:id).sort)
      end
    end
  end

  describe 'after_update send_approval_email_to_user' do
    let(:new_user) { create(:user, :guest) }

    context 'when some other attribute changes' do
      it 'does not send an email' do
        new_user.update(name: Faker::Name.name)

        assert_emails 0
      end
    end

    context 'when role changed' do
      it 'sends an email' do
        new_user.recruiter!

        assert_emails 1
      end
    end
  end

  describe 'when updading users calendly link' do
    let(:employer) { create(:user, :employer) }

    subject { employer.update(calendly_link: link) }

    context 'with full url provided' do
      let(:link) { 'https://meet.google.com' }

      it 'updates successfully' do
        is_expected.to be_truthy
      end
    end

    context 'with invalid link' do
      let(:link) { '11' }

      it 'throws an error' do
        is_expected.to be_falsy
        expect(employer.errors.messages).to have_key(:calendly_link)
        expect(employer.errors.messages[:calendly_link]).to include('Valid URL required')
      end
    end
  end
end

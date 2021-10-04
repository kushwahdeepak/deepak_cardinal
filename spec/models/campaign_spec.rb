require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'initialize' do
    context 'with valid attributes' do
      let(:job) { create(:job) }
      let(:user) { create(:user) }

      it 'all attributes are present' do
        campaign = Campaign.create(
          source_address: Faker::Internet.email,
          subject: Faker::Lorem.sentence,
          content: Faker::Lorem.paragraph,
          user_id: user.id,
          job_id: job.id
          )
        expect(campaign).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'when source_address is blank' do
        campaign = build(:campaign, source_address: '')
        expect(campaign).not_to be_valid
      end

      it 'when subject is blank' do
        campaign = build(:campaign, subject: '')
        expect(campaign).not_to be_valid
      end

      it 'when content is blank' do
        campaign = build(:campaign, content: '')
        expect(campaign).not_to be_valid
      end

      it 'when user_id is blank' do
        campaign = build(:campaign, user_id: '')
        expect(campaign).not_to be_valid
      end

      it 'when job_id is blank' do
        campaign = build(:campaign, job_id: '')
        expect(campaign).not_to be_valid
      end
    end
  end
end

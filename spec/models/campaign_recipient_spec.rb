require 'rails_helper'

RSpec.describe CampaignRecipient, type: :model do
  describe 'initialize' do
    let(:job) { build(:job) }
    let(:user) { build(:user) }
    let(:person) { create(:person) }
    let(:campaign) { create(:campaign) }

    context 'with valid attributes' do
      it 'is valid' do
        campaign_recipient = CampaignRecipient.create(
          contact_recipient_at: Date.today,
          recipient_id: 1,
          campaign_id: campaign.id)
        expect(campaign_recipient).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'when contact_recipient_at is blank' do
        campaign_recipient = build(:campaign_recipient, contact_recipient_at: '')
        expect(campaign_recipient).to_not be_valid
      end

      it 'when campaign_id is blank' do
        campaign_recipient = build(:campaign_recipient, campaign_id: '')
        expect(campaign_recipient).to_not be_valid
      end

      it 'when recipient_id is blank' do
        campaign_recipient = build(:campaign_recipient, recipient_id: '')
        expect(campaign_recipient).to_not be_valid
      end
    end

    context 'find_contacted_recipients' do
      let(:job) { create(:job) }
      let(:contacted_person) { create(:person) }
      let!(:uncontacted_person) { create(:person) }
      let!(:campaign) { create(:campaign, duration_days: 1, job_id: job.id) }
      let!(:contacted_recipient) do
        create(
          :campaign_recipient,
          contact_recipient_at: Date.today,
          recipient_id: contacted_person.id,
          campaign_id: campaign.id
        )
      end

      it 'returns only contacted recipients' do
        contacted_people_ids = described_class.find_contacted_recipients(job.id, 'month').pluck(:recipient_id)
        contacted_people = Person.where(id: contacted_people_ids)

        expect(Person.count).to eq(2)
        expect(contacted_people).to eq([contacted_person])
        expect(contacted_people.count).to eq(1)
      end
    end
  end
end

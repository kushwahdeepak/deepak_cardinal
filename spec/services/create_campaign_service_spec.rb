require 'rails_helper'

RSpec.describe CreateCampaignService, type: :service do
  let!(:uncontacted_people) { create_list(:person, 5) }
  let!(:contacted_people) { create_list(:person, 5) }
  let(:employer) { create(:user, :employer, organization: create(:organization)) }
  let(:job) { create(:job, organization_id: employer.organization.id, user: employer) }
  let(:campaign_params) {{
    source_address: 'example@example.com',
    subject: 'Subject',
    content: 'Content',
    job_id: job.id,
    user_id: employer.id
  }}

  let(:campaign) { create(:campaign, job_id: job.id, duration_days: 1) }

  let(:email_credentials_params) {{
    email_address: 'example@example.com',
    password: 'password'
  }}

  let!(:contacted_recipients) do
    contacted_people.each do |contacted_user|
      create(
        :campaign_recipient,
        contact_recipient_at: Date.today,
        recipient_id: contacted_user.id,
        campaign_id: campaign.id,
        organization_id: employer.organization.id
      )
    end
  end

  it 'should create campaigns only for uncontacted_users' do
    list_of_recipient_ids = Person.ids

    expect {
      described_class.new(list_of_recipient_ids, campaign_params, email_credentials_params).call
    }.to change { CampaignRecipient.count }.by(uncontacted_people.count)
  end
end

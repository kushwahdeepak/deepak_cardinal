require 'spec_helper'

RSpec.describe CampaignsController, type: :controller do
  let(:owner) { create(:user, role: :employer) }

  before {  sign_in(owner) }

  describe '/campaigns_controller/index' do 
    before(:all) do 
      3.times{ FactoryBot.create(:campaign) }
    end

    it "renders index page" do 
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @campaigns var" do 
      get :index
      expect(assigns(:campaigns).count).to eq(3)
    end
  end

  describe '/campaigns_controller/show' do   
    it "renders show page" do 
      campaign = FactoryBot.create(:campaign)
      get :show, params: {id: campaign.id}
      expect(response).to render_template(:show)
    end

    it "assigns @campaign_recipients var" do
      campaign = FactoryBot.create(:campaign)
      FactoryBot.create(:campaign_recipient, campaign_id: campaign.id)
      get :show, params: {id: campaign.id}
      expect(assigns(:campaign_recipients).count).to eq(1)
    end
  end

  describe '/campaigns_controller/update_recipient_mail_status' do 
    it "update @campaign_recipient mail status with :sent" do 
      recipient = FactoryBot.create(:campaign_recipient)
      expect(recipient.status).to eq("pending")
      post :update_recipient_mail_status, params: {campaign_id: recipient.campaign_id, recipient_id: recipient.recipient_id}
      expect(assigns(:campaign_recipient).status).to eq("sent")
    end
  end

  describe '/campaigns_controller/create' do
    before do
      create_list(:person, 3)
      allow(OutgoingMailService).to receive(:send_email_params).and_return(true)
    end

    context "with valid parameters" do
      let(:job) { create(:job, creator_id: owner.id) }
      let!(:organization) { create(:organization, owner: owner, users: [owner], name: 'Some org name') }
      let(:valid_params) do
        {
          campaign: {
            source_address: 'TEST@TEST.com',
            subject: 'Test Subject',
            content: 'Test Content',
            user_id: owner.id,
            job_id: job.id,
          },
          list_of_recipient_ids: Person.all.pluck(:id),
          email_credentials: {
            password: 'test!234',
            email_address: 'Test@Test.com'
          }
        }
      end

      it 'should create a new campaign with valid params' do
        expect { post :create, params: valid_params }.to change(Campaign, :count).by(+1)
        expect(response).to have_http_status :created
        expect(response.header['Content-Type']).to include('application/json')
        expect(Campaign.last[:subject].to_s).to eq 'Test Subject'
      end

      it 'should create a new campaign with sending email credentials' do
        expect { post :create, params: valid_params }.to change(Campaign, :count).by(+1)
        expect(response).to have_http_status :created
        expect(response.header['Content-Type']).to include('application/json')
        expect(Campaign.last[:subject].to_s).to eq 'Test Subject'
      end
    end
  end
end

require 'rails_helper'

# Legacy Code | Outdate | Replace by webhook/incoming_mail_controller
RSpec.describe IncomingMailsController, type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:job) { create(:job, user: recruiter) }
  let!(:person) { create(:person, user: recruiter) }
  let!(:submission) { create(:submission, person: person, job: job, user: recruiter) }
  let!(:incoming_mail) { create(:incoming_mail) }
  let(:params) do
    {
      mail: {
        plain: File.read('spec/fixtures/incoming_mails/plain.txt'),
        subject: "[#{job.id}] Some text in subject",
        reply: recruiter.email,
        from: ENV['INCOMING_GATEWAY_ADDRESS']
      }
    }
  end

  before { allow(OutgoingMailService).to receive(:send_email_params).and_return(OpenStruct.new({success?: true, payload: 'success'})) }

  describe 'authenticated actions' do
    let!(:recruiter) { create(:user, :recruiter) }

    context 'while user is admin' do
      before(:each) do
        sign_in(admin, scope: :user)
      end

      it 'get #index has a 200 status code' do
        get '/incoming_mails'

        expect(response.status).to eq 200
      end

      it 'get #new has a 200 status code' do
        get '/incoming_mails/new'

        expect(response.status).to eq 200
      end

      it 'get #show has a 200 status code' do
        get "/incoming_mails/#{incoming_mail.id}"

        expect(response.status).to eq 200
      end
    end

    context 'while user is not an admin' do
      before(:each) do
        sign_in(recruiter, scope: :user)
      end

      it 'get #index  responds with 302' do
        get '/incoming_mails'

        expect(response.status).to eq 302
      end

      it 'get #new responds with 302' do
        sign_in(recruiter, scope: :user)
        get '/incoming_mails/new'

        expect(response.status).to eq 302
      end

      it 'get #show responds with 302' do
        get "/incoming_mails/#{incoming_mail.id}"

        expect(response.status).to eq 302
      end
    end
  end

  describe 'unauthenticated actions' do
    let!(:recruiter) { create(:user, :recruiter) }

    it "actions that require authentication don't work when user is not authenticated" do
      get '/incoming_mails'
      expect(response).to have_http_status 302
      expect(response.location).to include "users/sign_in"
    end

    it "only the post works without authentication" do
      post '/incoming_mails', params: params
      expect(response).to have_http_status 200
    end
  end

  describe 'post #create' do
    let!(:recruiter) { create(:user, :recruiter) }

    subject { post '/incoming_mails', params: params }

    before { allow(OutgoingMailService).to receive(:send_email_params).and_return(true) }

    context 'with valid attributes' do
      it 'creates new consume questioner email' do
        params[:mail][:from] = person.email_address
        params[:file] = fixture_file_upload('spec/fixtures/incoming_mails/resume.pdf', 'application/pdf')

        expect { subject }.to change { IncomingMail.count }.by(1)

        expect(response.status).to eq 200
        expect(IncomingMail.last.plain).to eq(params[:mail][:plain])
        expect(IncomingMail.last.attachment.attached?).to be true
        expect(Person.last.notes).not_to be_nil
      end

      it 'creates new consume linkedin submission email' do
        params[:file] = fixture_file_upload('spec/fixtures/incoming_mails/resume.pdf', 'application/pdf')

        expect { subject }.to change { IncomingMail.count }.by(1)

        expect(response.status).to eq 200
        expect(IncomingMail.last.plain).to eq(params[:mail][:plain])
        expect(IncomingMail.last.attachment.attached?).to be true
        expect(Person.last.email_address).to eq "baron.a.mui@gmail.com"
        expect(Person.last.resume_text).not_to be_nil
      end
    end

    context 'top20percentCandidate' do
      it 'tags candidate as top 20 percent' do
        params[:file] = fixture_file_upload('spec/fixtures/incoming_mails/resume.docx', 'application/msword')
        params[:mail][:plain] = params[:mail][:plain].gsub('The Ohio State University', 'MIT')

        expect { post '/incoming_mails', params: params }.to change { IncomingMail.count }.by(1)

        expect(response.status).to eq 200
        expect(IncomingMail.last.plain).to eq(params[:mail][:plain])
        expect(IncomingMail.last.attachment.attached?).to be true
      end
    end

    context 'with invalid attributes' do
      it 'creates an email' do
        params[:file] = fixture_file_upload('spec/fixtures/incoming_mails/invalid.pdf', 'application/pdf')

        post '/incoming_mails', params: params

        expect(IncomingMail.last.candidate_email).to eq ''
      end
    end
  end

  describe 'employee response' do
    before { get '/incoming_mails/employer_response', params: { answer: 'yes', submission_id: submission.id } }

    context 'with calendly link' do
      let!(:recruiter) { create(:user, :recruiter, calendly_link: 'https://meet.google.com/axw-aenq-tzm') }

      it 'returns successul response' do
        allow(OutgoingMailService).to receive(:send_email_params).with(anything()).and_return(OpenStruct.new({success?: true, payload: {}}))
        expect(response.status).to eq 200
      end
    end

    context 'without calendly link' do
      let!(:recruiter) { create(:user, :recruiter) }

      it 'returns an error message without calling OutgoingMailService' do
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        expect(json_body).to have_key('error')
        expect(json_body['error']).to include("User #{recruiter.email} doesn't have calendly link")
      end
    end
  end
end

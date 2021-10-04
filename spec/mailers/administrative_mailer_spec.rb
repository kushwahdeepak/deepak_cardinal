require 'rails_helper'
include Mail::Matchers

RSpec.describe 'AdministrativeMailer', type: :mailer do
  let(:new_user) { create(:user, :guest) }
  let(:admin) { create(:user, :admin) }

  before(:each) do
     Mail::TestMailer.deliveries.clear
  end

  describe 'creates mail' do
    context 'for admin about new user' do
      let(:mail) { AdministrativeMailer.email_to_admin_about_new_user(user: new_user, role: :recruiter).deliver }

      it { expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com') }

      it { expect(mail.subject).to match("#{new_user.email} created") }
    end

    context 'to user when he approved' do
      let(:mail) { AdministrativeMailer.email_to_user_about_approval(user: new_user).deliver }

      it { expect(mail.to).to have_sent_email.to(new_user.email) }

      it { expect(mail.subject).to match("approved") }
    end

    context 'for admin about new import job' do
      describe 'sends job that imported with text' do
        let(:import_job_info) {{ other: Faker::Lorem.paragraph }}
        it "sends without logo" do
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.body).to match(import_job_info[:other])
        end

        it "sends with logo" do
          import_job_info[:logo] = fixture_file_upload('spec/fixtures/avatar.jpeg', 'image/jpeg')
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.body.parts.first.body).to match(import_job_info[:other])
          expect(mail.body.parts.last.content_type).to match('image/jpeg')
        end
      end

      describe 'sends job that imported with url' do
        let(:import_job_info) {{ job_url: Faker::Internet.url }}

        it "sends without logo" do
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.body).to match(import_job_info[:job_url])
        end

        it 'sends with logo' do
          import_job_info[:logo] = fixture_file_upload('spec/fixtures/avatar.jpeg', 'image/jpeg')
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.parts.first.body).to match(import_job_info[:job_url])
          expect(mail.body.parts.last.content_type).to match('image/jpeg')
        end
      end

      describe 'sends job that imported by file' do
        let(:import_job_info) {{
            file: fixture_file_upload('spec/fixtures/incoming_mails/resume.pdf', 'application/pdf')
          }}

        it "sends without logo" do
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.body.parts.last.content_type).to eq('application/pdf')
          expect(mail.body.parts.first.body).to match("in attached file.")
        end

        it 'sends with logo' do
          import_job_info[:logo] = fixture_file_upload('spec/fixtures/avatar.jpeg', 'image/jpeg')
          mail = AdministrativeMailer.send_email_about_import_job(import_job_info).deliver

          expect(mail.to).to have_sent_email.to('access-requests@cardinalhire.com')
          expect(mail.subject).to match("imported")
          expect(mail.body.parts.second.content_type).to match('application/pdf')
          expect(mail.body.parts.last.content_type).to match('image/jpeg')
          expect(mail.body.parts.first.body).to match("in attached file.")
        end
      end
    end
  end
end

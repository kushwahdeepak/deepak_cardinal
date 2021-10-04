require "rails_helper"

RSpec.describe CandidateSubmissionsMailer, type: :mailer do
  let(:user) { create(:user, :recruiter, calendly_link: 'http://meet.google.com') }
  let(:person) { create(:person, user: user, first_name: 'joe', last_name: 'chmo') }
  let(:job) { create(:job, creator_id: user.id) }
  let(:incoming_mail) { create(:incoming_mail) }
  let(:submission) { create(:submission, user: user, person: person, job: job) }

  before :each do
    Mail::TestMailer.deliveries.clear
  end

  describe :email_employer_about_candidate_interested do
    ENV['HOST'] = 'http://localhost:3000'
    it "sends the email" do
      params = {
        submission: submission,
        reply: "test"
      }
      mail = CandidateSubmissionsMailer.with(params).email_employer_about_candidate_interested(params).deliver_now
      expect(mail.subject).to include 'joe chmo'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq [ENV.fetch('OUTGOING_EMAIL_USERNAME')]
      assert_emails 1
    end
  end

  describe :email_to_top20_about_greeting do
    it 'sends the mail' do
      ap  Rails.application.config.action_mailer.smtp_settings
      params = {
        job:  job,
        candidate_name: person.name,
        company_name: job.portalcompanyname,
        candidate_email: person.email_address
      }
      mail = CandidateSubmissionsMailer.with(params).email_to_top20_about_greeting(params).deliver_now
      expect(mail.subject).to include "Thank you for applying for #{job.name}"
      expect(mail.to).to eq [person.email_address]
      expect(mail.from).to eq [ENV.fetch('OUTGOING_EMAIL_USERNAME')]
      assert_emails 1
    end
  end

  describe :email_candidate_about_employer_interested do
    let(:params) {
      {
        person: person,
        job: job
      }
    }

    it 'sends the mail' do
      ap  Rails.application.config.action_mailer.smtp_settings
      mail = CandidateSubmissionsMailer.with(params).email_candidate_about_employer_interested(params).deliver_now
      expect(mail.subject).to include "Scheduling an Interview with #{params[:job].portalcompanyname}"
      expect(mail.to).to eq [person.email_address]
      expect(mail.from).to eq [ENV['OUTGOING_EMAIL_USERNAME']]
      expect(mail.body.raw_source).to include(job.user.calendly_link)
      assert_emails 1
    end
  end

  describe 'send mails when somebody applies to new job' do
    let(:params) {
      {
        employer: submission.user,
        applicant: submission.person,
        job: submission.job
      }
    }

    context 'when applicant applies to job' do
      it 'sends an email to applicant' do
        mail = CandidateSubmissionsMailer.email_applicant_when_applies_to_job(params).deliver
        expect(mail.subject).to include "CardinalTalent: You were applied to job #{params[:job].name}"
        expect(mail.to).to eq [params[:applicant].email_address]
        expect(mail.from).to eq [ENV['OUTGOING_EMAIL_USERNAME']]
        assert_emails 1
      end
    end

    it 'sends an email to employer' do
      mail = CandidateSubmissionsMailer.notify_employer_about_new_applicant(params).deliver
      expect(mail.subject).to include "CardinalTalent: New applicant #{params[:applicant].name} applied to job #{params[:job].name}"
      expect(mail.to).to eq [params[:employer].email]
      expect(mail.from).to eq [ENV['OUTGOING_EMAIL_USERNAME']]
      assert_emails 1
    end
  end
end

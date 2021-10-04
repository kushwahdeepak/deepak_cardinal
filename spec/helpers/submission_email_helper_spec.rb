require 'rails_helper'

RSpec.describe SubmissionEmailHelper, type: :helper do
  let(:talent) { create(:user, :talent) }
  let(:recruiter) { create(:user, :recruiter) }
  let(:talent_person) { create(:person, user: talent, tags: Person::TOP_2O_PERCENT_TAG) }
  let(:job) { create(:job) }

  context 'when talent applies  to job' do
    it 'sends an email when talent in top 20 persent applies to a job' do
      submission = create(:submission, user: talent, job: job, person: talent_person)
      template = send_mails_about_appliying_to_a_job(submission: submission)

      expect(template.body.parts.first.body).to include(talent_person.name)
      expect(template.subject).to include(job.name)
    end
  end

  context 'when recruiter applies talent to job' do
    describe 'when talent is top 20' do
      it 'sends email' do
        submission = create(:submission, user: recruiter, job: job, person: talent_person)
        template = send_mails_about_appliying_to_a_job(submission: submission)

        expect(template.body.parts.first.body).to include(talent_person.name)
        expect(template.subject).to include(job.name)
      end
    end

    describe 'when talent is not top 20' do
      it 'not sends email' do
        talent_person.update(tags: '')
        submission = create(:submission, user: recruiter, job: job, person: talent_person)
        expect(send_mails_about_appliying_to_a_job(submission: submission)).to be nil
      end
    end
  end

  context 'when submission creates by email' do
    let(:incoming_mail_params) {
      {
        'mail' => {
          'plain' => File.read('spec/fixtures/incoming_mails/plain.txt'),
          'subject' => "Resume for job [#{job.id}] from #{talent.name}",
          'date' => Date.today,
          'from' => Faker::Internet.email
        },
        'file' => fixture_file_upload('spec/fixtures/incoming_mails/resume.pdf', 'application/pdf')
      }
    }

    describe 'talent in top 20' do
      it 'sends email' do
        # incoming_mail = IncomingMail.create_mail(incoming_mail_params)
        # person = incoming_mail.persist_candidate_from_email_and_parsed_mail
        # person.update(tags: Person::TOP_2O_PERCENT_TAG)

        # submission = incoming_mail.persist_submission
        # template = send_mails_about_appliying_to_a_job(submission: submission)

        # expect(template.body.parts.first.body).to include(person.name)
        # expect(template.body.parts.last.content_type).to eq('application/pdf')
        # expect(template.subject).to include(job.name)
      end
    end
  end
end

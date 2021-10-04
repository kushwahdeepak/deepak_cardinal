require 'rails_helper'

describe ConversationOrchestrator do 
  before(:each) do 
    User.destroy_all
    Submission.destroy_all
    Job.destroy_all
    IncomingMail.destroy_all
  end
  
  before do
    allow(OutgoingMailService).to receive(:send_email_params).and_return(OpenStruct.new({success?: true }))
  end

  context ".respond_to" do 
    it "triggers outgoing mail service" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission, parsed_job_id: 2)
      job = FactoryBot.create(:job, id: 2)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      expect( ConversationOrchestrator.respond_to(mail)[:success?] ).to eq(true)
    end
  end

  context ".consume_linkedin_submission_email" do 
    it "create person obj if its not found by candidate mail" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission)
      job = FactoryBot.create(:job, id: 2)
      expect{ConversationOrchestrator.consume_linkedin_submission_email(mail)}.to change(Person, :count).by(1)
    end

    it "doesn't create person obj if its found by candidate mail" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission)
      job = FactoryBot.create(:job, id: 2)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      expect{ConversationOrchestrator.consume_linkedin_submission_email(mail)}.to change(Person, :count).by(0)
    end

    it "creates email params top 20 greeting" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission)
      job = FactoryBot.create(:job, id: 2)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      expect(ConversationOrchestrator.consume_linkedin_submission_email(mail)[:subject]).to eq("Thank you for applying for #{job.name} [#{job.id}]")
    end
  end

  context ".consume_candidate_questionnaire_email" do 
    it "raises exception if submission not found" do 
      mail = FactoryBot.create(:incoming_mail, :submission, from: "candidatemail@mail.com")
      job = FactoryBot.create(:job, id: 2)
      person = FactoryBot.create(:person, email_address: "candidatemail@mail.com")
      expect{ConversationOrchestrator.consume_candidate_questionnaire_email(mail)}.to raise_error("couldn't locate submission for job:#{job.id}, person:#{person.id}.")
    end

    it "sets parsed job id on mail" do 
      mail = FactoryBot.create(:incoming_mail, :submission, from: "candidatemail@mail.com")
      job = FactoryBot.create(:job, id: 2)
      person = FactoryBot.create(:person, email_address: "candidatemail@mail.com")
      submission = FactoryBot.create(:submission, job: job, incoming_mail: mail, person: person)
      expect(mail.parsed_job_id).to be_blank
      ConversationOrchestrator.consume_candidate_questionnaire_email(mail)
      mail.reload
      expect(mail.parsed_job_id).to be(2)
    end

    it "returns the right hash for emailing" do 
      mail = FactoryBot.create(:incoming_mail, :submission, from: "candidatemail@mail.com")
      user = FactoryBot.create(:user)
      job = FactoryBot.create(:job, id: 2, user: user)
      person = FactoryBot.create(:person, email_address: "candidatemail@mail.com")
      submission = FactoryBot.create(:submission, job: job, incoming_mail: mail, person: person)
      response = ConversationOrchestrator.consume_candidate_questionnaire_email(mail)
      expect(response[:reply]).to eq(mail.reply)
      expect(response[:recipient_email]).to eq(user.email)
      expect(response[:file_url]).to eq(person.resume_url)
      expect(response[:file_name]).to eq(person.resume.blob.filename)
      expect(response[:email_type]).to eq("email_employer_about_candidate_interested")
    end
  end

  context ".find_submission" do 
    it "raises error if job is not found" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      expect{ConversationOrchestrator.find_submission(person, mail)}.to raise_error("The subject >#{mail.subject}< doesn't contain valid job_id.")
    end

    it "raises error if submission is not found" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission, parsed_job_id: 2)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      job = FactoryBot.create(:job, id: 2)
      expect{ConversationOrchestrator.find_submission(person, mail)}.to raise_error("couldn't locate submission for job:#{mail.parsed_job_id}, person:#{person.id}.")
    end

    it "returns submission" do 
      mail = FactoryBot.create(:incoming_mail, :submission, :linkedin_submission, parsed_job_id: 2)
      person = FactoryBot.create(:person, tags: ["top20percentCandidate"], email_address: "candidatemail@mail.com")
      job = FactoryBot.create(:job, id: 2)
      submission = FactoryBot.create(:submission, job: job, incoming_mail: mail, person: person)
      expect( ConversationOrchestrator.find_submission(person, mail).person_id ).to eq(person.id)
      expect( ConversationOrchestrator.find_submission(person, mail).job_id ).to eq(job.id)
    end
  end
end
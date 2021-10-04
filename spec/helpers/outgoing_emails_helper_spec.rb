require "rails_helper"

RSpec.describe OutgoingEmailsHelper do
  describe ".candidate_interested" do
    it "returns a string" do
      employer_name = "bob"
      candidate_name = "joe"
      submission_id = 1
      template = OutgoingEmailsHelper.candidate_interested(employer_name, candidate_name, submission_id, "test")
      expect(template).to include(employer_name)
      expect(template).to include(candidate_name)
      expect(template).to include(submission_id.to_s)
    end
  end

  describe ".employer_interested" do
    it "returns a string" do
      candidate_name = "bob"
      calendly_link = 'https://meet.google.com/axw-aenq-tzm'
      template = OutgoingEmailsHelper.employer_interested(candidate_name, calendly_link)
      expect(template).to include(candidate_name)
      expect(template).to include(calendly_link)
    end
  end

  describe ".top_20_greeting" do
    it "returns a string" do
      candidate_name = "bob"
      job_name = "engineer"
      company_name = "google"
      template = OutgoingEmailsHelper.top_20_greeting("bob", "engineer", "google")
      expect(template).to include(candidate_name)
      expect(template).to include(job_name)
      expect(template).to include(company_name)
    end
  end

  describe '.inject_unsubscribe_link_in_campaign' do
    it 'returns a string' do
      content   = 'Test content'
      person_id = 1
      user_id   = 2
      template = OutgoingEmailsHelper.inject_unsubscribe_link_in_campaign(content, person_id, user_id)
      expect(template).to include(content)
      expect(template).to include("#{ENV['HOST']}/blacklists/unsubscribe?person_id=#{person_id}&user_id=#{user_id}")
    end
  end
end
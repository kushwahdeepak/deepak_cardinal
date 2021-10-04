class Conversations
  class EunexpectedEmailError < StandardError; end
  def self.log msg
    submission.person.add_note msg
    logger.info msg
  end
  def self.on_submission_by_top20candidate_via_linkedin submission
    log "top20 candidate submitted vuia linked-in submission:#{submission.id}.  "+
      "Sending him an email greeting"
    CandidateSubmissionsMailer.with(submission:submission).email_to_top20_about_greeting.deliver_now

  end
  def self.on_interest_from_top20candidate submission
    log("A top 20% candidate responded. submission:#{submission.id}." +
      "  Sending employer an email to see if he is interested")
    CandidateSubmissionsMailer.with(submission:submission).email_to_top20_about_greeting.deliver_now
  end
  def self.on_intertest_by_employer submission
    log("employer is interested in candidate. submission:#{submission.id}. "+
      "  Sending email to candidate about it")
    CandidateSubmissionsMailer.with(submission:submission).email_candidate_about_employer_interested
    #send email to candidate
    #add note

  end
end
# Legacy Code , this service not used with new incoming mail webhook

class ConversationOrchestrator

  EMAIL_TYPE_TOP_20_GREETING = "email_to_top20_about_greeting"
  EMAIL_TYPE_CANDIDATE_INTERESTED = "email_employer_about_candidate_interested"

  def self.respond_to incoming_mail
    if incoming_mail.from_email === ENV.fetch("INCOMING_GATEWAY_ADDRESS")
      outgoing_email_params = self.consume_linkedin_submission_email incoming_mail
    else
      outgoing_email_params = self.consume_candidate_questionnaire_email incoming_mail
    end
    if outgoing_email_params.present?
      Rails.logger.info "outgoing_mail_params #{outgoing_email_params}"
      OutgoingMailService.send_email_params outgoing_email_params
    end
  end

 private

  def self.consume_linkedin_submission_email incoming_mail
    person = incoming_mail.persist_candidate_from_email_and_parsed_mail
    Rails.logger.info "Done persist_candidate_from_email_and_parsed_mail ."
    submission = incoming_mail.persist_submission
    Rails.logger.info "Done persist_submission ."
    job = Job.find_by_id(incoming_mail.parsed_job_id&.to_i)

    if person&.top_20_percent? && job.present?
      Rails.logger.info "Candidate is top 20 percent.  Send email."

      content = OutgoingEmailsHelper.top_20_greeting(person.name, job.name, job.portalcompanyname)
      subject = "Thank you for applying for #{job.name} [#{job.id}]"

      params = {
        recipient_email: person.email_address,
        sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
        subject: subject,
        content: content,
        email_type: EMAIL_TYPE_TOP_20_GREETING
      }
    end
  end

  def self.consume_candidate_questionnaire_email incoming_mail
    Rails.logger.info "consume candidate email"
    person = Person.find_by_email incoming_mail.from
    if !person.present?
      Rails.logger.warn "recieved email from unknown address #{incoming_mail.from}."
      Rails.logger.debug "questionnaire response: #{incoming_mail.plain}."
      return
    end
    incoming_mail.set_job_id_from_subject

    note = "received questionnaire response fom #{person.email_address} about job #{incoming_mail.parsed_job_id}: "+ incoming_mail.plain
    person.add_note note
    Rails.logger.info note

    submission = find_submission person,incoming_mail
    job = Job.find_by_id(incoming_mail.parsed_job_id)
    user = job.user

    content = OutgoingEmailsHelper.candidate_interested(user.first_name, person.first_name, submission.id, incoming_mail.reply)
    subject = "New Cardinal Talent Candidate (#{job.name}): #{submission.person.name}"

    params = {
      recipient_email: user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      reply: incoming_mail.reply,
      file_url: person.resume_url,
      file_name: person.resume.blob.filename,
      email_type: EMAIL_TYPE_CANDIDATE_INTERESTED
    }
  end

  def self.find_submission person,incoming_mail
    (Job.find_by_id(incoming_mail.parsed_job_id)) || (
    raise Exception.new "The subject >#{incoming_mail.subject}< doesn't contain valid job_id.")
    (submission = Submission.find_by_person_and_job person.id,incoming_mail.parsed_job_id).present? || (
    raise Exception.new "couldn't locate submission for job:#{incoming_mail.parsed_job_id}, person:#{person.id}.")
    @submssion = submission
  end
end

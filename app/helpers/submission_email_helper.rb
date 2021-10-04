module SubmissionEmailHelper
  def send_mails_about_appliying_to_a_job(submission:)
    if submission&.person&.top_20_percent?
      CandidateSubmissionsMailer.email_applicant_when_applies_to_job(params_for_mails(submission)).deliver_now
      CandidateSubmissionsMailer.notify_employer_about_new_applicant(params_for_mails(submission)).deliver_now
    end
  end

  private

  def params_for_mails(submission)
    attachment = submission&.incoming_mail&.attachment || submission&.person&.resume
    {
      employer: submission&.job&.user,
      applicant: submission&.person,
      job: submission&.job,
      attachment: attachment,
      notifiedemails: submission&.job&.notificationemails
    }
  end
end

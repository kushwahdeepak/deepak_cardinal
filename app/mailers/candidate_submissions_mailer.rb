class CandidateSubmissionsMailer < ApplicationMailer
  default from: ENV.fetch('OUTGOING_EMAIL_USERNAME')
  default reply_to: ENV.fetch('INCOMING_MAIL_ADDRESS')

  def email_to_top20_about_greeting params #email candidate that employers wants interview
     @params = params
    mail(
     to: params[:candidate_email],
     subject: "Thank you for applying for #{params[:job].name} [#{params[:job].id}]."
    )
  end
  def email_employer_about_candidate_interested params #email employer that candidate is interested
    @param = params
    mail(
      to: params[:submission].job.user.email,
      subject: "New Cardinal Talent Candidate (#{@params[:submission].job.name}): #{@params[:submission].person.name}"
    )
  end

  def email_candidate_about_employer_interested params #email candidae with offer to schedule
    @params = params
    mail(
      to: @params[:person].email_address,
      subject: "Scheduling an Interview with #{@params[:job].portalcompanyname}"
    )
  end

  def email_applicant_when_applies_to_job(params)
    @params = params
    mail(
      to: @params[:applicant].email_address,
      subject: "CardinalTalent: You were applied to job #{@params[:job].name}"
    )
  end

  def notify_employer_about_new_applicant(params)
    @params = params
    attachment = @params[:attachment]

    if attachment.present? && attachment.attached?
      begin
        attachments["#{attachment.blob.filename.to_json}"] = {
          mime_type: attachment.blob.content_type,
          content: attachment.blob.download
          }
      rescue Aws::S3::Errors::ServiceError => e
        attachments["#{attachment.blob.filename.to_json}"] = {}
      end
    end

    mail(
      to: [@params[:employer].email, @params[:notifiedemails]],
      subject: "CardinalTalent:#{@params[:applicant].name} does applied for #{@params[:job].name}"
    )
  end
end

class GuestPersonMailer < ApplicationMailer
    default from: "noreply@cardinaltalent.ai"
  
    def sample_email(person, job_title, email_id, recruiter_name)
      @person = person
      @job_title = job_title
      @email = email_id
      @creator_name = recruiter_name
      resume = @person.resume
      if resume.present? && resume.attached?
        begin
            attachments["#{resume.blob.filename.to_json}"] = {
            mime_type: resume.blob.content_type,
            content: resume.blob.download
            }
        rescue Aws::S3::Errors::ServiceError => e
            attachments["#{resume.blob.filename.to_json}"] = {}
        end
      end
      mail(to: @email, subject: 'CardinalTalent: New Guest Person')
    end
end
  
class AdministrativeMailer < ApplicationMailer
  default to: 'access-requests@cardinalhire.com'

  def email_to_admin_about_new_user(user:, role:)
    @user = user
    @role = role

    mail(subject: "CardinalTalent: New Account for #{@user.email} created")
  end

  def email_to_user_about_approval(user:)
    @user = user

    @url = "#{ENV['HOST']}/users/profile"

    mail(to: @user.email, subject: "CardinalTalent: Your request was approved")
  end

  def email_to_user_about_organization_approval(organization:)
    @organization = organization

    mail(to: @organization.owner.email, subject: "CardinalTalent: Your organization was approved")
  end

  def send_email_about_import_job(import_job_info)
    @import_job_info = import_job_info
    attachment = @import_job_info[:file]
    @logo = @import_job_info[:logo]

    attachments["#{attachment.original_filename}"] = {
      mime_type: attachment.content_type,
      content: attachment.read
    } if attachment.present?

    attachments.inline["#{@logo.original_filename}"] = File.read(open(@logo)) if @logo.present?

    mail(subject: "CardinalTalent: New job was imported, please approve")
  end
end

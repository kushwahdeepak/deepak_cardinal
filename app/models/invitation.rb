class Invitation < ApplicationRecord
  PENDING = 'pending'.freeze
  ACCEPTED = 'accepted'.freeze
  REJECTED = 'rejected'.freeze

  belongs_to :organization
  belongs_to :inviting_user, class_name: 'User'
  belongs_to :invited_user, class_name: 'User'

  validates :organization, presence: true
  validates :inviting_user, presence: true
  validates :invited_user, presence: true

  def send_email_to_invite
    invited_user_name = "#{invited_user&.first_name} #{invited_user&.last_name}"
    inviting_user_name = "#{inviting_user&.first_name} #{inviting_user&.last_name}"
    content = OutgoingEmailsHelper.inviting_user(inviting_user_name, invited_user_name, organization.name, self.id)
    subject = "Organization Invitation"

    params = {
      recipient_email: invited_user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end
end

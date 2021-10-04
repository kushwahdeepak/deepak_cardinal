class Referral < ApplicationRecord

  validates :invitee_name, presence: true
  validates :invitee_email, presence: true

  belongs_to :user, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :job

  before_create :create_token

  def create_token
    self.invitee_code = generate_token
  end

  def self.update_signup_date(token)
    self.find_referral_by_invitee_code(token)&.update(signup_date: Time.now)
  end

  def self.update_job_applied_date(token)
    self.find_referral_by_invitee_code(token)&.update(job_applied_date: Time.now)
  end

  def invitation(referral_id)
    @referral = Referral.find_by(id: referral_id)
    @job = @referral.job  
    @user = @referral.user
    @url = "#{ENV['HOST']}/jobs/#{@job.try(:id)}?token=#{@referral.invitee_code}"

    @referral.update(email_send_date: Time.now)

    content = OutgoingEmailsHelper.invite_to_apply(@referral,@job,@user,@url)
    subject = "Invited for applying new job"

    params = {
      recipient_email: @referral.invitee_email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params

  end

  private

  def generate_token
    loop do
      token = SecureRandom.hex(4)
      break token if Referral.where(invitee_code: token).blank?
    end
  end

  def self.find_referral_by_invitee_code(token)
    find_by(invitee_code: token)
  end

end

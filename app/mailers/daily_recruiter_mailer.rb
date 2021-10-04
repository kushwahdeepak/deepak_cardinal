class DailyRecruiterMailer < ApplicationMailer
  default from: "noreply@cardinaltalent.ai"

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'CardinalTalent: Important Reminder', bcc: ['hello@joshuazapata.com'])
  end
end

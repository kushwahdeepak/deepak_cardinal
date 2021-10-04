class DailyReportMailer < ApplicationMailer
  default from: "noreply@cardinaltalent.ai"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_report_mailer.daily_report_email.subject
  #
  def daily_report_email(user)
    @user = user
    @recruiters = User.where(role: "member")

    mail(to: @user.email, subject: 'CardinalTalent: Daily Activity Report', bcc: ['hello@joshuazapata.com'])
  end
end

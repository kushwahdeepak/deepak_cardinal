class MonthlyReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.monthly_report_mailer.monthly_report_email.subject
  #
  def monthly_report_email(user)
    @user = user
    @recruiters = User.where(role: "member")

    mail(to: @user.email, subject: 'CardinalTalent: Monthly Activity Report', bcc: ['hello@joshuazapata.com'])
  end
end

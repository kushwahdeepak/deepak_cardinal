class WeeklyReportMailer < ApplicationMailer
  default from: "noreply@cardinaltalent.ai"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.weekly_report_mailer.report_email.subject
  #
  def weekly_report_email(admin)
    @user = admin
    @recruiters = User.where(role: "recruiter")

    mail(to: @user.email, subject: 'CardinalTalent: Weekly Activity By Sourcer')
  end
end

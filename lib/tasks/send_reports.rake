require 'date'
namespace :send_reports do
  desc "Sends the reports"
  task :send_reports => :environment do
    if Time.zone.now.tuesday?
      admins = User.where(role: "admin")
      for admin in admins
        WeeklyReportMailer.weekly_report_email(admin).deliver
      end
    end
  end
end

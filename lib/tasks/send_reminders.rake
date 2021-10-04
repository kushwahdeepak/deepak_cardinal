require 'date'
task :send_reminders => :environment do
  if Time.zone.now.saturday?
    return
  elsif Time.zone.now.sunday?
    return
  else
    users = User.all
    for user in users
      if user.role == "member" || user.role == "admin"
        if user.recruiter_updates.where('created_at >= ?', 2.days.ago).count < 1
          if user.email == 'teamleon@gmail.com'
            return
          elsif user.email == 'paul@cardinalhire.com'
            return
          elsif user.email == 'paul.campbell@stanfordalumni.org'
            return
          elsif user.email == 'paul.campbell@alumni.standford.edu'
            return
          elsif user.email == 'paulcampbell456@gmail.com'
            return
          elsif user.email == 'paul.campbell@anaplan.com'
            return
          elsif user.email == 'paul.campbell@limebike.com'
            return
          else
            DailyRecruiterMailer.reminder_email(user).deliver
          end
        end
      end
    end
  end
end

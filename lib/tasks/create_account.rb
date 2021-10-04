desc "Doesn't work. Well the code does.  Rake doesn't.  Rake can't find it" #todo fix it
task :create_account do

  class Reseter
    public
    EMAILS_TMP = [
    ]
    CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
    def self.random_password(length=10)
      CHARS.sort_by { rand }.join[0...length]
    end
    def self.reset_pwds_by_emails emails

      LinkedinProfileEducation.delete_all
      LinkedinProfilePosition.delete_all
      Search.delete_all
      #raise 'not authorized' unless current_user.role == 'admin'

      rval = {}
      emails.each do |email|
        u = User.where('email=?', email)
        u[0].delete if(u.size > 0)

        pwd = Reseter.random_password
        u = User.new(email: email, password: pwd, password_confirmation: pwd, accepts: true, accepts_date: Date.today, role: 'recruiter')
        u.save!
        rval[email]=pwd
      end
      puts rval
    end
  end

  Reseter.reset_pwds_by_emails Reseter::EMAILS_TMP


end
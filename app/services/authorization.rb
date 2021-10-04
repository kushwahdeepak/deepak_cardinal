# class Authorization
#   def self.people_search?(user)  user.admin? || user.recruiter? || user.employer? end
#   def self.people_intake?(user) user.admin? || user.recruiter? end
#   def self.jobs_view?(user) user.admin? || user.recruiter? || user.employer? || user.talent? end
#   def self.notes_view?(user)  user.admin? || user.recruiter? end
#   def self.jobs_create?(user) user.admin? || user.recruiter? || user.employer? end
#   def self.job_update?(user, record) user.admin? || record.user == user end
#   def self.admin?(user) user.admin? end
# end

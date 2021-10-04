module Admins
  class AdminInfornationService
    def call
      get_admin_info
    end

    private

    def get_admin_info
      [
        {
          name: 'candidates',
          total_count: User.talent.count,
          today_count: User.talent.where("DATE(created_at) = ?", Date.today).count
        },
        {
          name: 'jobs',
          total_count: Job.active_only.joins(:organization).count,
          today_count: Job.where("DATE(created_at) = ?", Date.today).count
        },
        {
          name: 'recruiters',
          total_count: User.recruiter.count,
          today_count: User.recruiter.where("DATE(created_at) = ?", Date.today).count
        },
        {
          name: 'organizations',
          total_count: Organization.joins(:owner).where('users.email ~* ?',"").count,
          today_count: Organization.where("DATE(created_at) = ?", Date.today).count
        }
      ]
    end
  end
end

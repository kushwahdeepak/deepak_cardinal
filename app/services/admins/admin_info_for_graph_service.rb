module Admins
  class AdminInfoForGraphService
    attr_reader :dates

    def initialize
      @dates = ((Date.today - 6.days)..Date.today)
    end

    def call
      get_info
    end

    private

    def get_info
      week_info = []

      dates.each do |day|

        week_info << {
          date: day.strftime('%d %b'),
          candidates_count: User.talent.where("DATE(created_at) = ?", day).count,
          jobs_count: Job.where("DATE(created_at) = ?", day).count,
          recruites_count: User.recruiter.where("DATE(created_at) = ?", day).count,
          organizations_count: Organization.where("DATE(created_at) = ?", day).count,
        }
      end

      week_info
    end
  end
end

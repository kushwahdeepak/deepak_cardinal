namespace :cleanup_interviews do
  desc "removes stale and inactive interviews from the database"
  task :interviews => :environment do
    # Find all the interviews older than yesterday, that are not active yet
    stale_interviews = Interview.where("DATE(created_at) < DATE(?)", Date.yesterday).where("status is not 'active'")

    # delete them
    stale_interviews.map(&:destroy)
  end
end

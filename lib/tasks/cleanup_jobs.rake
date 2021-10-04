namespace :cleanup_jobs do
  desc "Expire jobs after 30 days"
  task :jobs => :environment do
    thresh = Job::EXPIRATION_PERIOD_DAYS.days.ago
    jobs_count = Job.expire_jobs
    puts "Expire all #{jobs_count.to_s} jobs that were created before #{thresh.to_s} "
  end
end



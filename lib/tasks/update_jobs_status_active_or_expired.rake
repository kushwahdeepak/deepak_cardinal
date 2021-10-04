namespace :update_jobs_status_active_or_expired do
  desc "IF JOB ACTIVE COLUMN IS TRUE THEN SET STATUS IS ACTIVE AND JOB ACTIVE COLUMN IS FALSE THEN SET STATUS IS EXPIRED"
  task update_job_status: :environment do
    Job.where(active: true).update_all(status: Job.statuses[:active])
    Job.where(active: false).update_all(status: Job.statuses[:expired])
  end
end
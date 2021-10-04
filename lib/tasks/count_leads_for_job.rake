namespace :jobs do

  desc 'Count leads for all jobs.'
  task count_leads_for_jobs: :environment do
    Job.all.each do |job|
      job.update_column(:leads_count, Job.jobs_lead_metrics(job&.user&.id, job.id))
    end
  end
end

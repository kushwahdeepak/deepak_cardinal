namespace :job_stage_status do
  desc "Update Job Stage Count"
  task :job_stage => :environment do
    JobStageWorker.perform_async
  end
end

class JobStageWorker
  include Sidekiq::Worker

  def perform
    Job.all.find_each(batch_size: 100) do |job|
      submission = nil
      JobStageStatus.stage_count(job.id, job.creator_id, submission)
    end
  end
end

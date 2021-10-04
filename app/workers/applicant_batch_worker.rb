class ApplicantBatchWorker
  include Sidekiq::Worker

  def perform
    ApplicantBatch.applicant_all_not_done
  end
end

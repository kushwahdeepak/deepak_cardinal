class BulkImportJob
  include Sidekiq::Worker

  def perform
    ImportJob.intake_all_not_done
  end
end

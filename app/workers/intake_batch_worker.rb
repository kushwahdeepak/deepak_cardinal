class IntakeBatchWorker
  include Sidekiq::Worker
  
  def perform
    IntakeBatch.intake_all_not_done
  end
end

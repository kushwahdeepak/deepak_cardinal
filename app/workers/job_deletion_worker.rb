class JobDeletionWorker
  include Sidekiq::Worker

  def perform
    ActiveRecord::Base.transaction do
      begin
        Job.where("created_at < ?", 60.days.ago).destroy_all
      rescue => error
        puts "Error throwing #{error}"
        raise ActiveRecord::Rollback
      end
    end
  end
end

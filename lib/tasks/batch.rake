namespace :scheduled do
    task applicant_batches: :environment do
      Rails.logger.debug "starting applicant batches"
      ApplicantBatchWorker.perform_async
    end
    task ping: :environment do #gonna use this one at the beginning to make sure shceduler works
      puts 'ping'
    end
  end

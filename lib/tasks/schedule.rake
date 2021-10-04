namespace :scheduled do
  task deactiveate_candidates: :environment do
    thresh = Person::EXPIRATION_PERIOD_MONTHS.months.ago
    count  = Person.deactivate_outdated
    puts "Deactivated all #{count.to_s} candidates that were activated before #{thresh.to_s} "
  end
  task intake_batches: :environment do
    Rails.logger.debug "starting intake batches"
    IntakeBatchWorker.perform_async
  end
  task ping: :environment do #gonna use this one at the beginning to make sure shceduler works
    puts 'ping'
  end

  task export_candidates_for_new_job: :environment do
    ExportTopCandidatesJob.perform_now if Date.today.monday?
  end
end

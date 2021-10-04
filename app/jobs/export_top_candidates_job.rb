class ExportTopCandidatesJob < ActiveJob::Base
  require 'csv'

  self.queue_adapter = :sidekiq
  queue_as :mailers

  def perform
    csv = ExportCandidatesService.new.call
    TopCandidatesMailer.csv_email(csv).deliver
  end
end

class BulkImportCandidate
  include Sidekiq::Worker

  def perform(file_paths)
    UploadCandidatesCsv.new(file_paths).file_import
  end

end

require 'csv'
class ApplicantBatch < ApplicationRecord
  include ApplicantBatchUpload
  has_one_attached :applicant_file
end

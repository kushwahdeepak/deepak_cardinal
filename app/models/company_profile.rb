class CompanyProfile < ApplicationRecord
  has_many :company_profile_jobs
  has_many :jobs, through: :company_profile_jobs
  scope :filter_company, -> (filter_word) {
    where("LOWER(company_name) LIKE ?", "%#{filter_word.downcase}%")
  }
end

class CompanyProfileJob < ApplicationRecord
  belongs_to :company_profile
  belongs_to :job
end

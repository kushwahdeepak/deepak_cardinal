class CompanyPosition < ApplicationRecord
  belongs_to :linkedin_profile_position
  belongs_to :person
  belongs_to :email_address
  belongs_to :user
end

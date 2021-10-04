class JobExperience < ApplicationRecord
  belongs_to :person

  # Validations
  validates :person_id, presence: true
  validates_uniqueness_of :title, scope: [:company_name, :location, :person_id]
end

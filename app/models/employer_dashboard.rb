class EmployerDashboard < ApplicationRecord
  self.table_name = 'employer_dashboard'

  belongs_to :organization
  belongs_to :job
end
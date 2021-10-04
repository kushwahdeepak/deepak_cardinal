class EmployerSequenceToPerson < ApplicationRecord
  belongs_to :person
  belongs_to :email_sequence
end

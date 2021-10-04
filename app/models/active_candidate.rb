class ActiveCandidate < ApplicationRecord
  belongs_to :person
  belongs_to :job
end

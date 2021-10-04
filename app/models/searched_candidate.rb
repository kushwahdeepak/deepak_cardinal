class SearchedCandidate < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :person, optional: true
  acts_as_followable
end

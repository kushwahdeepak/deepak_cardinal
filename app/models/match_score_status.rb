class MatchScoreStatus < ApplicationRecord
  belongs_to :person

  enum status: %i[initial in_progress completed]
end

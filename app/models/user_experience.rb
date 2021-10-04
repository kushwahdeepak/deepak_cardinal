class UserExperience < ApplicationRecord
  belongs_to :user_profile, inverse_of: :user_experiences, optional: true
end

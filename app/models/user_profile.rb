class UserProfile < ApplicationRecord
  belongs_to :user, inverse_of: :user_profiles
  has_many :user_experiences, inverse_of: :user_profile, :dependent => :destroy
  has_many :user_educations, inverse_of: :user_profile, :dependent => :destroy

  accepts_nested_attributes_for :user_experiences, :allow_destroy => true
  accepts_nested_attributes_for :user_educations, :allow_destroy => true
end

class UserEducation < ApplicationRecord
  belongs_to :user_profile, inverse_of: :user_educations, optional: true
  has_many :user_education_jobs
  has_many :jobs, through: :user_education_jobs
  scope :filter_university, -> (filter_word) {
    where("LOWER(name) LIKE ?", "%#{filter_word.downcase}%")
  }
end

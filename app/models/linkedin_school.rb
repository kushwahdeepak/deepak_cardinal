# == Schema Information
#
# Table name: linkedin_schools
#
#  id                             :integer          not null, primary key
#  name                           :string
#  logo_url                       :string
#  internal_logo_url              :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  linkedin_profile_educations_id :integer
#  linkedin_profile_education_id  :integer
#

class LinkedinSchool < ApplicationRecord
  belongs_to :linkedin_profile_education
  has_many :linkedin_profiles, through: :linkedin_profile_education
end

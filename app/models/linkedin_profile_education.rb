# == Schema Information
#
# Table name: linkedin_profile_educations
#
#  id                         :integer          not null, primary key
#  linkedin_profile_id        :integer
#  school_name                :string
#  field_of_study             :string
#  degree                     :string
#  start_date                 :date
#  start_date_year            :integer
#  start_date_month           :integer
#  end_date                   :date
#  end_date_year              :integer
#  end_date_month             :integer
#  activities                 :string
#  notes                      :string
#  linkedin_field_of_study_id :integer
#  linkedin_school_id         :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class LinkedinProfileEducation < ApplicationRecord
  has_many :linkedin_schools
  has_many :linkedin_field_of_studies
  has_many :linkedin_profiles, through: :linkedin_profile_education, source: :user
  belongs_to :user
  has_one :person
end

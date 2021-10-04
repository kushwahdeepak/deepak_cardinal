# == Schema Information
#
# Table name: linkedin_profile_publications
#
#  id                            :integer          not null, primary key
#  linkedin_profile_id           :integer
#  title                         :string
#  date                          :date
#  date_year                     :integer
#  date_month                    :integer
#  linkedin_profile_id_id        :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  linkedin_profile_education_id :integer
#

class LinkedinProfilePublication < ApplicationRecord
  belongs_to :linkedin_profile
  has_many :people, through: :linkedin_profile
end

# == Schema Information
#
# Table name: linkedin_industries
#
#  id                   :integer          not null, primary key
#  name                 :string
#  group                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  linkedin_profile_id  :integer
#  linkedin_profiles_id :integer
#

class LinkedinIndustry < ApplicationRecord
  belongs_to :linkedin_profile
  has_many :people, through: :linkedin_profile
end

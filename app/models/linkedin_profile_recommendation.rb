# == Schema Information
#
# Table name: linkedin_profile_recommendations
#
#  id                  :integer          not null, primary key
#  text                :string
#  type                :string
#  recommender_id      :integer
#  linkedin_profile_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  table_type          :string
#

class LinkedinProfileRecommendation < ApplicationRecord
  belongs_to :linkedin_profile
  has_many :people, through: :linkedin_profile
end

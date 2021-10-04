# == Schema Information
#
# Table name: linkedin_profiles
#
#  id                             :integer          not null, primary key
#  public_profile_url             :string
#  headline                       :string
#  linkedin_industry_id           :integer
#  person_id                      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  first_name                     :string
#  last_name                      :string
#  formatted_name                 :string
#  location_name                  :string
#  location_country_code          :string
#  picture_url                    :string
#  internal_picture_url           :string
#  connections                    :integer
#  num_recommenders               :integer
#  skills                         :string
#  following_industries           :string
#  associations                   :string
#  proposal_comments              :string
#  summary                        :string
#  interests                      :string
#  internal_picture_url_lg        :string
#  picture_url_lg                 :string
#  cse_picture_url                :string
#  cse_picture_url_thumb          :string
#  internal_cse_picture_url       :string
#  internal_cse_picture_url_thumb :string
#  specialties                    :string
#  linkedin_profile_id            :integer
#  crelate_id                     :string
#  createdon                      :datetime
#  categorytypeid                 :string
#  targetentityid                 :string
#  targetentityid_type            :string
#  value                          :string
#  isprimary                      :boolean
#  createdonsystem                :datetime
#

class LinkedinProfile < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_skills, :against => :skills

  has_one :person
  has_one :user
  has_one :email_address

  has_many :linkedin_industries

  has_many :linkedin_profile_educations
  has_many :linkedin_field_of_studies, through: :linkedin_profile_educations
  has_many :linkedin_schools, through: :linkedin_profile_educations

  has_many :linkedin_profile_positions
  has_many :company_positions, through: :linkedin_profile_positions

  has_many :linkedin_profile_publications
  has_many :linkedin_profile_recommendations
  has_many :linkedin_profile_url_resources
end

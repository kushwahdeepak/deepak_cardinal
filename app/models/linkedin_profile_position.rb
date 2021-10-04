# == Schema Information
#
# Table name: linkedin_profile_positions
#
#  id                     :integer          not null, primary key
#  linkedin_profile_id    :integer
#  company_name           :string
#  is_current             :boolean
#  start_date             :date
#  start_date_year        :integer
#  start_date_month       :integer
#  end_date               :date
#  end_date_year          :integer
#  end_date_month         :integer
#  title                  :string
#  summary                :string
#  locality               :string
#  linkedin_profile_id_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  person_id              :integer
#

class LinkedinProfilePosition < ApplicationRecord
  belongs_to :user
  has_many :company_positions
  has_one :person
end

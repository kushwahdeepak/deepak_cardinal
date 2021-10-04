# == Schema Information
#
# Table name: linkedin_field_of_studies
#
#  id                            :integer          not null, primary key
#  name                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  linkedin_profile_education_id :integer
#

class LinkedinFieldOfStudy < ApplicationRecord
end

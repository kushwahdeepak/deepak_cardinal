# == Schema Information
#
# Table name: linkedin_profile_url_resources
#
#  id                     :integer          not null, primary key
#  linkedin_profile_id    :integer
#  name                   :string
#  url                    :string
#  domain                 :string
#  linkedin_profile_id_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class LinkedinProfileUrlResource < ApplicationRecord
  belongs_to :linkedin_profile
  belongs_to :person
end

# == Schema Information
#
# Table name: email_addresses
#
#  id                  :integer          not null, primary key
#  email               :string
#  valid_confidence    :decimal(, )
#  person_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  credible            :boolean
#  linkedin_profile_id :integer
#  type                :string
#  status              :string

class EmailAddress < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :user, optional: true
  belongs_to :linkedin_profile, optional: true
end

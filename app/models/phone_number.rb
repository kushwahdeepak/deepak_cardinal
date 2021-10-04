# == Schema Information
#
# Table name: phone_numbers
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  person_id           :integer
#  createdon           :datetime
#  targetentityid      :string
#  targetentityid_type :string
#  categorytypeid      :string
#  value               :string
#  isprimary           :boolean
#  extension           :string
#  createdonsystem     :datetime
#  crelate_id          :string
#  people_id           :integer
#  linkedin_profile_id :integer
#  type                :string

class PhoneNumber < ApplicationRecord
  belongs_to :person

  private

  def landline_number
    [international_code, area_code, phone_number].join('   ')
  end

  def international_code
    self.country_code = ISO3166::Country[country_code]
    country_code.international_prefix
  end
end

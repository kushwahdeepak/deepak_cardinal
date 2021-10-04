# == Schema Information
#
# Table name: entries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require_relative '../../app/models/address_book'

class Entry < ApplicationRecord
  belongs_to :user

  def to_s
    "Name: #{name}\nPhone Number: #{phone_number}\nEmail: #{email}"
  end
end

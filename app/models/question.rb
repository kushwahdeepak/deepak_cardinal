# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  resolved   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :integer
#

class Question < ApplicationRecord
  has_many :answers
  belongs_to :person, optional: true
end

class PhoneInterview < ApplicationRecord
  belongs_to :user
  belongs_to :person
  belongs_to :call_sheet
end

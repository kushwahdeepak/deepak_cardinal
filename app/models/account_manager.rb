class AccountManager < ApplicationRecord
  has_many :users
  has_many :accounts
end

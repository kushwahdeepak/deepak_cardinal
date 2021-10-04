class ClientAccount < ApplicationRecord
  has_many :managed_accounts
end

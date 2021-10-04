class ManagedAccount < ApplicationRecord
  belongs_to :client_accounts, optional: true
  belongs_to :user, optional: true
  has_many :jobs 
end

class SystemConfiguration < ApplicationRecord
  validates_uniqueness_of :name, presence: true
  validates :value, presence: true
end

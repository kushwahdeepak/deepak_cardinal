class DynamicPageContent < ApplicationRecord
    validates_uniqueness_of :name, presence: true
    validates :content, presence: true
  
    def find_by_name(name)
        SignUpContract.where(name: name).first
    end
  end
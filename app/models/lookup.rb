class Lookup < ApplicationRecord

  validates :name, presence: true
  validates :key, presence: true
  validates :value, presence: true
  
  scope :for_name, -> (name) do
  	where name: name
  end

  def as_json options={}
    with_id = options[:with_id] || false
    
    if with_id 
      { id: id, name: value }
    else
      { key: key, value: value }
    end
  end

  def self.create_for_name(name, values)
  	Lookup.where(name: name).destroy_all

  	records = []
  	values.each do |item|
  	  if item.class == Hash
  	  	records << { name: name, key: item[:key], value: item[:value] }
  	  else
  	  	records << { name: name, key: item, value: item }
  	  end
  	end

  	Lookup.bulk_insert values: records
  end

end
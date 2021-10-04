
class Location < ApplicationRecord

  include EsSearchable
  STATE = { "alabama"=> "AL", "alaska"=> "AK", "arizona"=> "AZ", "arkansas"=> "AR", "california"=> "CA", "colorado"=> "CO", "connecticut"=> "CT", "delaware"=> "DE", "district of Columbia"=> "DC", "florida"=> "FL", "georgia"=> "GA", "hawaii"=> "HI", "idaho"=> "ID", "illinois"=> "IL", "indiana"=> "IN", "iowa"=> "IA", "kansas"=> "KS", "kentucky"=> "KY", "louisiana"=> "LA", "maine"=> "ME", "maryland"=> "MD", "massachusetts"=> "MA", "michigan"=> "MI", "minnesota"=> "MN", "mississippi"=> "MS", "missouri"=> "MO", "montana"=> "MT", "nebraska"=> "NE", "nevada"=> "NV", "new Hampshire"=> "NH", "new Jersey"=> "NJ", "new Mexico"=> "NM", "new York"=> "NY", "north Carolina"=> "NC", "north Dakota"=> "ND", "ohio"=> "OH", "oklahoma"=> "OK", "oregon"=> "OR", "pennsylvania"=> "PA", "rhode Island"=> "RI", "south Carolina"=> "SC", "south Dakota"=> "SD", "tennessee"=> "TN", "texas"=> "TX", "utah"=> "UT", "vermont"=> "VT", "virginia"=> "VA", "washington"=> "WA", "west Virginia"=> "WV", "wisconsin"=> "WI", "wyoming"=> "WY" }

  has_many :jobs_locations
  # has_and_belongs_to_many :jobs,
  has_many :jobs, through: :jobs_locations

  scope :location_city_filter, -> (location_word) {
    where("LOWER(city) LIKE ? ", "%#{location_word.downcase}%")
  }

  scope :location_state_filter, -> (location_word) {
    where("LOWER(state) LIKE ? ", "%#{location_word.downcase}%")
  }

  settings do
    mappings dynamic: false do
      indexes :country, type: :text, analyzer: :english
      indexes :state, type: :text, analyzer: :english
      indexes :city, type: :text, analyzer: :english
    end
  end

  def as_indexed_json(options = {})
    as_json(
      only: [ :country, :state, :city]
    )
  end

  def to_str
    self.attributes.slice("country", "state", "city").select { |k, v| v.present? }.values.join(", ")
  end

  def self.query_search_engine_get_locations(location)
    __elasticsearch__.search(
      {
        size: 20,
        query: {
          multi_match: {
            query: location,
            fields: [ :country, :state, :city ],
          }
        }
      }
    )
  end

end

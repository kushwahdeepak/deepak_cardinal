require 'rails_helper'

describe 'LocationsController', type: :request do
  let(:owner) { create(:user, role: :employer) }

  before {  sign_in(owner) }

  describe 'search' do

    it 'by country' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit

      post '/locations/search', params: { location: 'united states' }

      results = JSON.parse(response.body)     
      expect(results['locations'].length).to eq 1
      expect(results['locations'].first['id']).to eq location1.id
    end
  end
end

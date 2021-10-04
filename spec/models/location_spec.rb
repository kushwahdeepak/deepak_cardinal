# spec/models/auction_spec.rb

require 'rails_helper'
require 'yaml'

RSpec.describe JobSearch, :type => :model do
  before(:each) do
    Sunspot.remove_all!   
  end

  describe 'searches location by keyword' do
    it 'by country ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('united states')
      expect(result.length).to eq 1
      expect(result.first.id).to eq location1.id
    end

    it 'by state ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('virginia')
      expect(result.length).to eq 1
      expect(result.first.id).to eq location1.id
    end

    it 'by city ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('alexandria')
      expect(result.length).to eq 2
      expect(result.map { |item| item.id }).to include location1.id
      expect(result.map { |item| item.id }).to include location2.id
    end

    it 'by country and state' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('Virginia US')
      expect(result.length).to eq 1
      expect(result.first.id).to eq location1.id
    end

    it 'by state and city ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('alexandria, virginia')
      expect(result.length).to eq 1
      expect(result.first.id).to eq location1.id
    end

    it 'by country and state and city ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'United States', state: 'Alexandria', city: 'Alexandria')
      Location.index
      Sunspot.commit
      result = Location.query_search_engine_get_locations('US alexandria, virginia')
      expect(result.length).to eq 1
      expect(result.first.id).to eq location1.id
    end
  end
end

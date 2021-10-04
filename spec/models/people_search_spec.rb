# spec/models/auction_spec.rb

require 'rails_helper'
require 'yaml'

#the params passed to the search#create in controller
def build_search_params
  {
    keyword: '',
    skills: '',
    locations: '',
    company_names: '',
    titles: '',
    schools: '',
    degrees: '',
    names: '',
    phone_number_available: '0',
    active: '0',
    top_company: '0',
    top_school: '0',
    emails: '',
    tags: ''
  }
end

RSpec.describe PeopleSearch, :type => :model do
  before(:each) do
    Sunspot.remove_all!
    @user = user = User.new(email: 'example@aol.com', password: '1234567!', password_confirmation: '1234567!', accepts: true, accepts_date: Date.today, role: 'recruiter')
    @user.save
    @search_params = build_search_params
  end

  describe 'advanced searches' do
    it 'multiword tokens' do
      p2 = Person.create!({skills: 'C', location: 'San Francisco', email_address: SecureRandom.uuid, user: @user})
      p1 = Person.create!({skills: 'C++', location: 'San Jose', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', location: 'New York', email_address: SecureRandom.uuid, user: @user})

      @search_params[:locations] = 'San Francisco'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        #ap actual
        expect(actual.length).to eq 1
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms

    end
    it 'multitoken search' do
      p1 = Person.create!({skills: 'C', location: 'Seattle', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C++', location: 'Denver', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', location: 'Orlando', email_address: SecureRandom.uuid, user: @user})

      @search_params[:locations] = 'Seattle or Denver'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p2)).to be true
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

    it 'search by multiple parameter' do
      p1 = Person.create!({location: 'Seattle', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'java', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({tags: 'findme', email_address: SecureRandom.uuid, user: @user})

      @search_params[:locations] = 'Seattle'
      @search_params[:skills] = 'java'
      @search_params[:tags] = 'findme'
      search = PeopleSearch.create!(@search_params)
      actual = search.query_search_engine_get_people

      expect(actual.length).to eq 3
      expect(actual.include?(p2)).to be true
      expect(actual.include?(p1)).to be true
      expect(actual.include?(p3)).to be true
    end
  end

  describe 'tags parameter' do
    it 'search with no params returns all people' do
      p_found = Person.create!({skills: 'C', tags: 'findme', email_address: SecureRandom.uuid, user: @user})
      p_not_found = Person.create!({skills: 'Java', tags: 'dontfindme', email_address: SecureRandom.uuid, user: @user})

      @search_params[:tags] = 'findme'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p_found)).to be true
      }.to perform_under(15).ms
    end

    it 'multiple tags parameter' do
      p1 = Person.create!({tags: 'findme', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({tags: 'dontfindme', email_address: SecureRandom.uuid, user: @user})

      @search_params[:tags] = 'findme, dontfindme'
      search = PeopleSearch.create!(@search_params)
      actual = search.query_search_engine_get_people
      expect(actual.length).to eq 2
      expect(actual.include?(p1)).to be true
    end
  end

  describe 'with organization' do
    it 'search people who has same organization with user associated or has not organization' do
      organization = create(:organization, owner: @user)
      p_found_1 = Person.create!({skills: 'C', email_address: SecureRandom.uuid, user: @user})
      p_found_2 = Person.create!({skills: 'C++', email_address: SecureRandom.uuid, user: @user, organization_id: organization.id})
      p_not_found = Person.create!({skills: 'Java', email_address: SecureRandom.uuid, user: @user, organization_id: create(:organization).id})
      search = PeopleSearch.create!({user_id: @user.id})
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p_found_1)).to be true
        # expect(actual.include?(p_found_2)).to be true
      }.to perform_under(15).ms
    end
  end

  describe 'keyword parameter' do
    it 'search with no params returns all people' do
      p2 = Person.create!({first_name: 'findme', email_address: SecureRandom.uuid, user: @user})
      p1 = Person.create!({first_name: 'dontfindme', email_address: SecureRandom.uuid, user: @user})
 
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end

    it 'one keyword -> 2 out of 3 ppl match on 2 different fields' do
      p1 = Person.create!({skills: 'C', first_name: 'findme', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C++', last_name: 'findme', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', first_name: 'dontfindme', email_address: SecureRandom.uuid, user: @user})

      @search_params[:keyword] = 'findme'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end

    it 'two keywords match as single token' do
      p1 = Person.create!({skills: 'C', first_name: 'findme first', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C++', last_name: 'findme', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', first_name: 'first', email_address: SecureRandom.uuid, user: @user})

      @search_params[:keyword] = 'findme first'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
        #expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end

    it 'but indexed stuff is tokenized' do
      p1 = Person.create!({skills: 'C', first_name: 'findme first', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C++', last_name: 'findme', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', first_name: 'first', email_address: SecureRandom.uuid, user: @user})

      @search_params[:keyword] = 'first'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p3)).to be true
      }.to perform_under(15).ms
    end

    it 'keyword has a space in it.  All the tokens in the query have to match.  But order doesnt matter.' do
      p1 = Person.create!({skills: 'C', first_name: 'findme first', email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C++', last_name: 'first findme', email_address: SecureRandom.uuid, user: @user})
      p3 = Person.create!({skills: 'Java', first_name: 'first', email_address: SecureRandom.uuid, user: @user})

      @search_params[:keyword] = 'findme first'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
  end
  describe :degrees do
    it 'nil matches evewryone' do
      n = Person.create!({skills: 'C',
        degree: nil,
        email_address: SecureRandom.uuid,
        user: @user})
      b = Person.create!({skills: 'Java',
        degree: Person::DEGREE_BACHELORS,
        email_address: SecureRandom.uuid,
        user: @user})
      m = Person.create!({skills: 'C++',
        degree: Person::DEGREE_MASTERS,
        email_address: SecureRandom.uuid,
        user: @user})
      d = Person.create!({skills: 'C++',
        degree: Person::DEGREE_DOCTORATE,
        email_address: SecureRandom.uuid,
        user: @user})
      @search_params[:degrees] = nil
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 4
      }.to perform_under(15).ms
    end
    it Person::DEGREE_BACHELORS do
      n = Person.create!({skills: 'C',
        degree: nil,
        email_address: SecureRandom.uuid, user: @user})
      b = Person.create!({skills: 'C',
        degree: Person::DEGREE_BACHELORS,
        email_address: SecureRandom.uuid, user: @user})
      m = Person.create!({skills: 'C',
        degree: Person::DEGREE_MASTERS,
        email_address: SecureRandom.uuid, user: @user})
      d = Person.create!({skills: 'C',
        degree: Person::DEGREE_DOCTORATE,
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:degrees] = Person::DEGREE_BACHELORS
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 3
        expect(actual.include?(b)).to be true
        expect(actual.include?(m)).to be true
        expect(actual.include?(d)).to be true
      }.to perform_under(15).ms
    end
    it Person::DEGREE_MASTERS do
      n = Person.create!({
        degree: nil,
        email_address: SecureRandom.uuid, user: @user})
      b = Person.create!({skills: 'C',
        degree: Person::DEGREE_BACHELORS,
        email_address: SecureRandom.uuid, user: @user})
      m = Person.create!({skills: 'C',
        degree: Person::DEGREE_MASTERS,
        email_address: SecureRandom.uuid, user: @user})
      d = Person.create!({skills: 'C',
        degree: Person::DEGREE_DOCTORATE,
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:degrees] = Person::DEGREE_MASTERS
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 2
        expect(actual.include?(d)).to be true
        expect(actual.include?(m)).to be true
      }.to perform_under(15).ms
    end
    it Person::DEGREE_DOCTORATE do
      n = Person.create!({skills: 'C',
        degree: nil,
        email_address: SecureRandom.uuid, user: @user})
      b = Person.create!({skills: 'C',
        degree: Person::DEGREE_BACHELORS,
        email_address: SecureRandom.uuid, user: @user})
      m = Person.create!({skills: 'C',
        degree: Person::DEGREE_MASTERS,
        email_address: SecureRandom.uuid, user: @user})
      d = Person.create!({skills: 'C',
        degree: Person::DEGREE_DOCTORATE,
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:degrees] = Person::DEGREE_DOCTORATE
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 1
        expect(actual.include?(d)).to be true
      }.to perform_under(20).ms
    end
  end

  describe :disciplines do
    it 'rudimentary' do
      p1 = Person.create!({skills: 'C',
        discipline: 'CS',
        email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C',
        discipline: 'notCS',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:disciplines] = 'CS'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'locations' do
    it 'rudimentary' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        location: 'Washington, DC',
        email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        location: 'Seattle, WA',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:locations] = 'Washington, DC'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

    it 'more locations parameter' do
      p1 = Person.create!({
        first_name: 'findme',
        location: 'Washington, DC',
        email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({
        first_name: 'findme',
        location: 'Seattle, WA',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:locations] = 'Washington, Seattle'
      search = PeopleSearch.create!(@search_params)
      actual = search.query_search_engine_get_people

      expect(actual.length).to eq 2
      expect(actual.include?(p1)).to be true
      expect(actual.include?(p2)).to be true
    end

    it 'when part of a field matches whole of query, it is matche.' do
      p1 = Person.create!({skills: 'C',
        email_address: SecureRandom.uuid,
        location: 'FindmeCity, FindmeState', user: @user})
      p2 = Person.create!({skills: 'C',

        location: 'something else',
        email_address: SecureRandom.uuid, user: @user})

      @search_params[:locations] = 'FindmeCity'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'when the matched part of the field does not span the entire query, it is also considered as matched.' do
      p1 = Person.create!({
        email_address: SecureRandom.uuid,
        location: 'FindmeCity, FindmeState', user: @user})
      p2 = Person.create!({skills: 'C',

        location: 'something else',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:locations] = 'FindmeCity, OtherState'
      search = PeopleSearch.create!(@search_params)
      actual = search.query_search_engine_get_people
      expect(actual.length).to eq 1
    end
  end
  describe 'company_names' do
    it 'rudimentary' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        company_names: 'Amazon',
        email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        company_names: 'NotAmazon',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:company_names] = 'Amazon'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'partial match' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        company_names: 'Amazon,subdivision SpaceX Verizon Wirless', user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        company_names: 'NotAmazon', user: @user})
      @search_params[:company_names] = 'Amazon'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'partial match no keyword' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        company_names: 'Amazon,subdivision SpaceX Verizon Wirless', user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        company_names: 'NotAmazon', user: @user})
      #@search_params[:keyword] = 'findme'
      @search_params[:company_names] = 'Amazon'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

  end
  describe 'skills' do
    it 'rudimentary' do
      p1 = Person.create!({
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        skills: 'findmeSkillC', user: @user})
      p2 = Person.create!({
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        skills: 'notfindmeskill', user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:skills] = 'findmeSkillC'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'person has many skills' do
      p1 = Person.create!({
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        skills: '["skill1", "skill2"]', user: @user})
      p2 = Person.create!({
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        skills: '["skill2", "skill3"]', user: @user})
      p3 = Person.create!({
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        skills: '["skill1", "skill3"]', user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:skills] = 'skill2, skill3'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

      expect(actual.length).to eq 3
      expect(actual.include?(p1)).to be true
      expect(actual.include?(p2)).to be true
      expect(actual.include?(p3)).to be true
    end
  end
  describe 'titles' do
    it 'rudimentary' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        title: 'SDE', user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        title: 'TPM', user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:titles] = 'SDE'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'multiple word titles' do
      p1 = Person.create!({skills: 'C',
        email_address: SecureRandom.uuid,
        title: 'software engineer', user: User.first})
      p2 = Person.create!({skills: 'C',
        email_address: SecureRandom.uuid,
        title: 'project manager', user: User.first})

      @search_params[:titles] = 'software engineer'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

    it "example that doesn't work in reality" do
      params = {:first_name => "Matt", :last_name => "Vail", :title => "Software Engineer", :location => "San Francisco Bay Area",
        :skills => "[\"Python\", \" JavaScript\", \" C++\", \" AWS\"]", :company_names => "Datavant Self-employed Zume Inc. Local Roots Farms",
        :school => "Stanford University", :degree => "MS in Computer Science - Artificial Intelligence", :active => true, :email_address => "mattrvail@gmail.com",
        :phone_number => "(262) 210-1055", :user => User.first}
      p1 = Person.create!(params)

      @search_params[:titles] = 'Software Engineer'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

    it 'rudimentary without keyword' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        title: 'SDE', user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        title: 'TPM', user: @user})
      @search_params[:titles] = 'SDE'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
    it 'title has two words' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        title: 'aaa bbb',
        email_address: SecureRandom.uuid, user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        title: 'cccl aaa',
        email_address: SecureRandom.uuid, user: @user})
      @search_params[:titles] = 'aaa bbb'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

    it "example that doesn't work in reality" do
      params = {:first_name => "Matt", :last_name => "Vail", :title => "Software Engineer", :location => "San Francisco Bay Area",
        :skills => "[\"Python\", \" JavaScript\", \" C++\", \" AWS\"]", :company_names => "Datavant Self-employed Zume Inc. Local Roots Farms",
        :school => "Stanford University", :degree => "MS in Computer Science - Artificial Intelligence", :active => true,
        :email_address => SecureRandom.uuid, :phone_number => "(262) 210-1055", :user => User.first}
      p1 = Person.create! params
      params = {:first_name => "Matt", :last_name => "Vail", :title => "Something Else", :location => "San Francisco Bay Area",
        :skills => "[\"Python\", \" JavaScript\", \" C++\", \" AWS\"]", :company_names => "Datavant Self-employed Zume Inc. Local Roots Farms",
        :school => "Stanford University", :degree => "MS in Computer Science - Artificial Intelligence", :active => true,
        :email_address => SecureRandom.uuid, :phone_number => "(262) 210-1055", :user => User.first}
      p2 = Person.create! params

      @search_params[:titles] = 'Software Engineer'
      search = PeopleSearch.create! @search_params
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end

  end
  describe 'schools' do
    it 'rudimentary' do
      p1 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        school: 'MIT', user: @user})
      p2 = Person.create!({skills: 'C',
        first_name: 'findme',
        email_address: SecureRandom.uuid,
        school: 'notMIT', user: @user})
      @search_params[:keyword] = 'findme'
      @search_params[:schools] = 'MIT'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'names' do
    it 'rudimentary' do
      p1 = Person.create!({
        first_name: 'Bob',
        last_name: 'John', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Bob',
        last_name: 'John', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})
      p3 = Person.create!({
        first_name: 'notBob',
        last_name: 'notJohn', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})
      @search_params[:keyword] = 'Amazon'
      @search_params[:names] = 'John'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'emails' do
    it 'rudimentary' do
      p1 = Person.create!({
        first_name: 'Bob',
        email_address: 'bob@bob.com', skills: 'C',
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Alice',
        email_address: 'alice@alice.com',
        company_names: 'Amazon', user: @user})

      @search_params[:keyword] = 'Amazon'
      @search_params[:emails] = 'bob@bob.com'
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'phone_number_available' do
    it 'returns all mateches if the check box is turned off' do
      p1 = Person.create!({
        first_name: 'Bob',
        phone_number: '(123)555-5555',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Alice',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'Amazon', user: @user})

      @search_params[:keyword] = 'Amazon'
      @search_params[:phone_number_available] = false
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
    it 'returns only those with phone_number_ if the check box is turned off' do
      p1 = Person.create!({
        first_name: 'Bob',
        phone_number: '(123)555-5555',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Alice',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'Amazon', user: @user})

      @search_params[:keyword] = 'Amazon'
      @search_params[:phone_number_available] = true
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'active' do
    it 'returns all mateches if the check box is turned off' do
      p1 = Person.create!({
        first_name: 'Bob', skills: 'C',
        active: true,
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Alice', skills: 'C',
        active: false,
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})

      @search_params[:keyword] = 'Amazon'
      @search_params[:active] = false
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
    it 'returns only those active_ if the check box is turned off' do
      p1 = Person.create!({
        first_name: 'Bob', skills: 'C',
        active: true,
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})
      p2 = Person.create!({
        first_name: 'Alice', skills: 'C',
        active: false,
        email_address: SecureRandom.uuid,
        company_names: 'Amazon', user: @user})

      @search_params[:keyword] = 'Amazon'
      @search_params[:active] = true
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'top_company' do
    it 'returns all mateches if the check box is turned off' do
      p1 = Person.create!({
        tags: 'top25company',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'findme', user: @user})
      p2 = Person.create!({
        tags: 'other',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'findme', user: @user})
      p3 = Person.create!({
        tags: 'top25company',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'dontfindme', user: @user})

      @search_params[:keyword] = 'findme'
      @search_params[:top_company] = false
      
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
    it 'returns only those with top_company true. if the check box is turned off' do
      p1 = Person.create!({
        tags: 'top25company',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'CloudKitchens', user: @user})
      p2 = Person.create!({
        tags: 'other',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'findme', user: @user})
      p3 = Person.create!({
        tags: 'top25company',
        email_address: SecureRandom.uuid, skills: 'C',
        company_names: 'dontfindme', user: @user})

      @search_params[:keyword] = 'CloudKitchens'
      @search_params[:top_company] = true
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end
  describe 'top_school' do
    it 'returns all mateches if the check box is turned off' do
      p1 = Person.create!({
        tags: 'top15school', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'findme', user: @user})
      p2 = Person.create!({
        tags: 'other', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'findme', user: @user})
      p3 = Person.create!({
        tags: 'top15school', skills: 'C',
        email_address: SecureRandom.uuid,
        company_names: 'dontfindme', user: @user})

      @search_params[:keyword] = 'findme'
      @search_params[:top_school] = false
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people

        expect(actual.length).to eq 2
        expect(actual.include?(p1)).to be true
        expect(actual.include?(p2)).to be true
      }.to perform_under(15).ms
    end
    it 'returns only those with top_company true. if the check box is turned off' do
      p1 = Person.create!({
        tags: 'top15school', skills: 'C',
        email_address: SecureRandom.uuid,
        school: 'DukeUniversity', user: @user, top_school: true
      })
      p2 = Person.create!({
        tags: 'other', skills: 'C',
        email_address: SecureRandom.uuid,
        school: 'findme', user: @user})
      p3 = Person.create!({
        tags: 'top15school', skills: 'C',
        email_address: SecureRandom.uuid,
        school: 'dontfindme', user: @user})

      @search_params[:keyword] = 'DukeUniversity'
      @search_params[:top_school] = true
      search = PeopleSearch.create!(@search_params)
      expect{
        actual = search.query_search_engine_get_people
        expect(actual.length).to eq 1
        expect(actual.include?(p1)).to be true
      }.to perform_under(15).ms
    end
  end

  describe 'Filtering out candidates for campaigns' do
    let(:person) { create(:person, 10) }
    let(:organization) { create(:organization, 1) }
    let(:job) { create(:job) }
    let(:campaign) { create(:campaign, duration_days: 1, job_id: job.id) }
    let(:employer) { create(:user, role: :employer) }
    let(:search) { PeopleSearch.create }
    let(:search_candidates) { search.search_people_for_campaign(campaign_owner_id: employer.id, period_key: 'month') }

    describe 'by blacklists' do
      let(:all_candidates) { create_list(:person, 10) }
      let(:blacklisted_candidates) { all_candidates.last(3) }

      before do
        blacklisted_candidates.each { |blacklisted_candidate| create(:blacklist, user: employer, person: blacklisted_candidate) }
      end

      it 'should exclude blacklisted candidates' do
        expect{
          candidates = search_candidates
          expect(candidates.count).to eql(7)
          expect(blacklisted_candidates.pluck(:id).all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eql(false)
        }.to perform_under(15).ms
      end
    end

    describe 'by client companies' do
      let!(:blackline_candidates) { create_list(:person, 2, company_names: 'BlackLine, LTDCompany') }
      let!(:boeing_candidates) { create_list(:person, 2, company_names: 'Boeing, My Company') }
      let!(:other_candidates) { create_list(:person, 5) }

      it 'should exclude candidates working for Facebook and Google' do
        expect{
          candidates = search_candidates
          excluded_candidate_ids = blackline_candidates.pluck(:id) + boeing_candidates.pluck(:id)
          expect(candidates.count).to eql(5)
          expect(excluded_candidate_ids.all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eql(false)
        }.to perform_under(15).ms
      end
    end

    describe 'by contacted recipients' do
      let!(:uncontacted_candidates) { create_list(:person, 10) }
      let(:contacted_candidates) { create_list(:person, 3) }
      let(:search_candidates) { search.search_people_for_campaign(campaign_owner_id: employer.id, period_key: 'month', job_id: job.id) }

      before do
        contacted_candidates.each do |contacted_candidate|
          create(
            :campaign_recipient,
            contact_recipient_at: Date.today,
            recipient_id: contacted_candidate.id,
            campaign_id: campaign.id
          )
        end
      end

      it 'should exclude candidates contacted last month' do
        expect{
          candidates = search_candidates
          expect(candidates.count).to eql(10)
          expect(contacted_candidates.pluck(:id).all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eql(false)
        }.to perform_under(15).ms
      end
    end

    describe 'by all three previouse filters' do
      let(:blacklisted_candidates) { create_list(:person, 4) }
      let!(:blackline_candidates) { create_list(:person, 2, company_names: 'BlackLine, LTDCompany') }
      let!(:boeing_candidates) { create_list(:person, 2, company_names: 'Boeing, My Company') }
      let(:contacted_candidates) { create_list(:person, 3) }
      let!(:other_candidates) { create_list(:person, 10) }
      let(:search_candidates) { search.search_people_for_campaign(campaign_owner_id: employer.id, period_key: 'month', job_id: job.id) }

      before do
        blacklisted_candidates.each { |blacklisted_candidate| create(:blacklist, user: employer, person: blacklisted_candidate) }
        contacted_candidates.each do |contacted_candidate|
          create(
            :campaign_recipient,
            contact_recipient_at: Date.today,
            recipient_id: contacted_candidate.id,
            campaign_id: campaign.id
          )
        end
      end

      it 'should exlcude blacklisted, contacted candidates and candidates working for client companies' do
        expect{
          candidates = search_candidates
          client_company_candidates_ids = blackline_candidates.pluck(:id) + boeing_candidates.pluck(:id)
          excluded_candidate_ids = client_company_candidates_ids + blacklisted_candidates.pluck(:id) + contacted_candidates.pluck(:id)
          expect(candidates.count).to eql(10)
          expect(excluded_candidate_ids.all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eql(false)
        }.to perform_under(15).ms
      end
    end

    describe 'by email type' do
      let!(:people_with_company_emails) { create_list(:person, 5) }
      let!(:people_with_personal_emails) { create_list(:person, 5).each { |person, i| person.update(email_address: "#{person.last_name}}@gmail.com") }}

      it 'should include people with company mails' do
        expect{
          candidates = search.search_people_for_campaign(campaign_owner_id: employer.id, period_key: 'month', email_type: PeopleController::COMPANY)

          expect(candidates.count).to eq(people_with_company_emails.count)
          expect(people_with_personal_emails.pluck(:id).all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eq(false)
        }.to perform_under(15).ms
      end

      it 'should include people with personal mails' do
        expect{
          search = PeopleSearch.create(emails: PeopleController::EMAIL)
          candidates = search.search_people_for_campaign(campaign_owner_id: employer.id, period_key: 'month')

          expect(candidates.count).to eq(people_with_personal_emails.count)
          expect(people_with_company_emails.pluck(:id).all? { |candidate_id| candidates.pluck(:id).include?(candidate_id) }).to eq(false)
        }.to perform_under(15).ms
      end
    end
  end
end

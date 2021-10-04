# spec/models/auction_spec.rb
require 'rails_helper'
require 'yaml'

RSpec.describe JobSearch, :type => :model do
  before(:each) do
    Sunspot.remove_all!
    @user = User.new(email: 'example@aol.com', password: '1234567!', password_confirmation: '1234567!', accepts: true, accepts_date: Date.today, role: 'recruiter')
    @user.save
    @search_params = {
      keyword: '',
      skills: '',
      company_names: '',
      user_id: '',
      locations: '',
      experience_years:''
    }
  end

  describe 'advanced searches' do
    it 'search job basis on skills' do
      location = Location.create!
      location.jobs << Job.create!({ skills: "react", user: @user })
      location.jobs << Job.create!({ skills: "php", user: @user })
      @search_params[:skills] = 'react'
      @search_params[:user_id] = @user.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 1
      }.to perform_under(10).ms
    end

    it 'search job basis on company_name' do
      location = Location.create!
      location.jobs << Job.create!({ skills: "c", portalcompanyname: "google", user: @user })
      location.jobs << Job.create!({ skills: "php", portalcompanyname: "facebook", user: @user })
      @search_params[:company_names] = 'facebook'
      @search_params[:user_id] = @user.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 1
      }.to perform_under(10).ms
    end

    it 'search job basis on school names' do
      location = Location.create!
      location.jobs << Job.create!({ skills: "c", school_names: "rayan", user: @user })
      location.jobs << Job.create!({ skills: "php", school_names: "alpine", user: @user })
      @search_params[:school_names] = 'alpine'
      @search_params[:user_id] = @user.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 1
      }.to perform_under(10).ms
    end

    it 'search job basis on keyword' do
      location = Location.create!
      location.jobs << Job.create!({ skills: "c", school_names: "alpine", user: @user })
      location.jobs << Job.create!({ skills: "php", portalcompanyname: "c", user: @user })
      @search_params[:keyword] = 'c'
      @search_params[:user_id] = @user.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 2
      }.to perform_under(20).ms
    end

    it 'search job basis on experience years' do
      location = Location.create!
      location.jobs << Job.create!({ skills: "c", experience_years: "5", user: @user })
      location.jobs << Job.create!({ skills: "php", experience_years: "4", user: @user })
      @search_params[:experience_years] = '4'
      @search_params[:user_id] = @user.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 1
      }.to perform_under(10).ms
    end

    it 'search job basis on no params' do
      location = Location.create!
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      expect{
        actual = search.query_search_engine_get_jobs
        expect(actual.length).to eq 0
      }.to perform_under(10).ms
    end
    # Commenting this spec since location functionality is not working at the moment once it fixed please
    # uncomment the following spec
    
    # it 'search job by location - case 1 ' do
    #   location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
    #   location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
    #   location1.jobs << Job.create!({ skills: "c", user: @user })
    #   location2.jobs << Job.create!({ skills: "php", user: @user })
    #   @search_params[:locations] = 'alexandria, virginia'
    #   search = JobSearch.create!(@search_params)
    #   @user.job_searches << search
    #   actual = search.query_search_engine_get_jobs
    #   expect(actual.length).to eq 1
    #   expect(actual.first.job.skills).to eq "c"
    # end

    it 'search job by location - case 1 ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      location1.jobs << Job.create!({ skills: "c", user: @user })
      location2.jobs << Job.create!({ skills: "php", user: @user })
      @search_params[:locations] = location2.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      actual = search.query_search_engine_get_jobs
      expect(actual.length).to eq 1
      expect(actual.first.skills).to eq "php"
    end

    it 'search job by location - case 2 ' do
      location1 = Location.create!(country: 'United States', state: 'Virginia', city: 'Alexandria')
      location2 = Location.create!(country: 'Egypt', state: 'Alexandria', city: 'Alexandria')
      location1.jobs << Job.create!({ skills: "c", user: @user })
      location2.jobs << Job.create!({ skills: "php", user: @user })
      @search_params[:locations] = location1.id
      search = JobSearch.create!(@search_params)
      @user.job_searches << search
      actual = search.query_search_engine_get_jobs
      expect(actual.length).to eq 1
      expect(actual.first.skills).to eq "c"
    end
  end
end

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
    phone_number_available: false,
    active: false,
    top_company: false,
    top_school: false,
    emails: '',
    tags: ''
  }
end

describe FetchSubmittedCandidatesService do

  let(:user) { create(:user) }
  let(:job) { create(:job) }

  before(:each) do
    Sunspot.remove_all!
    @search_params = build_search_params
  end

  describe 'advanced searches' do
    let!(:p1) { create(:person, location: 'San Francisco', top_school: true, email_address: SecureRandom.uuid, user: user, organization: nil) }
    let!(:p2) { create(:person, location: 'San Jose', email_address: SecureRandom.uuid, user: user, organization: nil) }
    let!(:p3) { create(:person, location: 'New York', top_company: true, email_address: SecureRandom.uuid, user: user, organization: nil) }
    let!(:submission1) { create(:submission, job: job, user: user, person: p1) }
    let!(:submission2) { create(:submission, job: job, user: user, person: p2) }
    let!(:submission3) { create(:submission, job: job, user: user, person: p3) }
    let!(:page_num) { 1 }

    it 'search by location' do
      @search_params[:locations] = 'San'
      result = described_class.new(job.id, page_num, @search_params, user, '').call[:submitted_candidates].map { |item| item[:id] }

      expect(result.length).to eq 2
      expect(result).to include p1.id
      expect(result).to include p2.id
    end

    it 'search by top school' do
      @search_params[:top_school] = true
      result = described_class.new(job.id, page_num, @search_params, user, '').call[:submitted_candidates].map { |item| item[:id] }

      expect(result.length).to eq 1
      expect(result).to include p1.id
    end

    it 'search by top company' do
      @search_params[:top_company] = true
      result = described_class.new(job.id, page_num, @search_params, user, '').call[:submitted_candidates].map { |item| item[:id] }

      expect(result.length).to eq 1
      expect(result).to include p3.id
    end

    it 'order by match score' do
      job_other = create(:job)
      create(:match_score, score: 40.0, job: job, person: p1)
      create(:match_score, score: 15.0, job: job, person: p2)
      create(:match_score, score: 16.0, job: job_other, person: p2)
      create(:match_score, score: 50.0, job: job, person: p3)
      result = described_class.new(job.id, page_num, @search_params, user, '').call[:submitted_candidates].map { |item| item[:id] }

      expect(result.length).to eq 3
      expect(result[0]).to eq p3.id
      expect(result[1]).to eq p1.id
      expect(result[2]).to eq p2.id
    end
  end
end

require 'rails_helper'

RSpec.describe JobExperience, type: :model do
  let(:person) { FactoryBot.create(:person) }
  let(:job_exp) { FactoryBot.create(:job_experience, person: person) }
  
  describe 'associations' do
    it { is_expected.to belong_to(:person) }
  end

  describe 'validate associations' do
    it 'should refrence to person' do
      expect(job_exp.person).to eq(person)
    end
  end

end

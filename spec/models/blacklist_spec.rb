require 'rails_helper'

RSpec.describe Blacklist, type: :model do
  let(:employer) { create(:user, role: :employer) }
  let(:candidate) { create(:user, role: :talent) }
  let(:candidate_person) { create(:person, user: candidate) }
  
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:person) }
  end

  describe 'association values' do
    let(:blacklist) { create(:blacklist, user: employer, person: candidate_person) }

    it 'has correct association values' do
      expect(blacklist.person).to eql(candidate_person)
      expect(blacklist.user).to eql(employer)
    end
  end
end

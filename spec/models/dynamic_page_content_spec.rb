require 'rails_helper'

RSpec.describe DynamicPageContent, type: :model do
  describe 'Table structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:content).of_type(:text) }
  end

  describe 'validation' do
    subject {
      described_class.new(name: 'aboutUsPage', content: 'This is about us page content')
    }

    context 'when name is not unique' do
      before { described_class.create!(name: 'aboutUsPage', content: 'This is about us page content') }
      it {expect(subject).to be_invalid}
    end

    context 'when name is unique' do
      before { described_class.create!(name: 'signUpPage', content: 'This is signUpPage') }
      it {expect(subject).to be_valid}
    end

    context 'content should presence' do
      it { is_expected.to validate_presence_of(:content) }
    end
  end
end
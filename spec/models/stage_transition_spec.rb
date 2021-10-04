require 'rails_helper'

RSpec.describe StageTransition, type: :model do
  describe 'Table structure' do
    it { is_expected.to have_db_column(:feedback).of_type(:text) }
    it { is_expected.to have_db_column(:stage).of_type(:string) }
  end

  describe 'Model relations' do
    it { is_expected.to belong_to(:submission) }
  end
end

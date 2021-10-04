
require 'rails_helper'

xdescribe IntakeBatch, type: :model do
  def simulate_file_upload(fixture_name)
    fixture_file_upload('intakeBatchBigTests/'+fixture_name, 'text/csv')
  end
  def create_batch_from_fixture fixture_name
    IntakeBatch.create(
      creator: @user,
      model_klass: 'Person',
      original_file: simulate_file_upload(fixture_name)
    )
  end
  before(:each) do
    @user = User.create!(email: 'example@aol.com', password: '1234567!', password_confirmation: '1234567!', accepts: true, accepts_date: Date.today, role: 'recruiter')

  end




  describe :intake do
    it 'long test' do
      Person.delete_all

      [
        'Stanford CS graduates 2000-2010.csv',
        'chIncomingCandidates-51-200430.csv',
        'chIncomingCandidates-101-200418.csv',
        'chIncomingCandidates-55-200427.csv',
        'chIncomingCandidates-101-200501.csv',
        'chIncomingCandidates-75-200429.csv',
        'chIncomingCandidates-110-200422.csv',
        'chIncomingCandidates-80-200505.csv',
        'chIncomingCandidates-50-200507.csv',
        'chIncomingCandidates-80-200506.csv',
        'chIncomingCandidates-50-200511.csv',
        'chIncomingCandidates-87-200504.csv'
      ].each do |f|
        puts "\n\n\n\n\n#{f}\n\n\n\n"
        b = create_batch_from_fixture f
        b.intake
        puts "\n\n\n\n\n#{b.log}\n\n\n\n"
      end
    end
  end
end



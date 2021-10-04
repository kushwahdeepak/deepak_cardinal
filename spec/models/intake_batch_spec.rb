require 'rails_helper'

RSpec.describe IntakeBatch, type: :model do
  def simulate_file_upload(fixture_name)
    fixture_file_upload(Rails.root.join('spec/fixtures', fixture_name), 'text/csv')
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
    @batch =  create_batch_from_fixture'batch_intake_mock_data.csv'
  end
  describe :intake_single do
    it 'creates model when unique email is provided' do
      returned_instance = @batch.intake_single 'Person', {email_address:'abc'}, @user
      expect(Person.last.email_address).to eql 'abc'
      expect(@batch.ok_count).to eql 1
      expect(Person.last.id).to be
      expect(Person.last.user.id).to eql @user.id
      expect(Person.last.id).to eql returned_instance.id
      #expect(@batch.people.size).to eql 1
      #expect(Person.last.intake_@batch.id).to eql @batch.id
      #expect(@user.intake_@batches.size).to eql 1
    end
    it 'increments failed counter when failure due to missing key'do
      @batch.intake_single 'Person', {}, @user
      expect(@batch.err_count).to eql 1
    end
    it 'increments failed counter when failure due to duplicate key'do
      @batch.intake_single 'Person', {email_address:'abc'}, @user
      @batch.intake_single 'Person', {email_address:'abc'}, @user
      expect(@batch.err_count).to eql 1
    end
  end
  describe :create do
    it 'saves the attached file to the cloud' do
      file = simulate_file_upload 'batch_intake_mock_data.csv'
      batch = IntakeBatch.create({
        creator: @user,
        model_klass: 'Person',
        original_file: file
      })
      expect(@batch.original_file.attached?).to be true
      from_db = IntakeBatch.find(@batch.id)
      expect(IntakeBatch.find(@batch.id)).to be

    end
  end
  describe :load_file do
    it 'roundtrip to cloud and back' do
      file = fixture_file_upload(Rails.root.join('spec/fixtures', 'batch_intake_mock_data.csv'), 'text/csv')
      batch = IntakeBatch.create({
        creator: @user,
        model_klass: 'Person',
        original_file: file
      })
      csv = batch.load_file
      expect(csv.first.to_hash['first_name']).to eql "Matt"
    end
  end

  describe :iterate_input_rows do
    it "intakes candidates in correct .csv file" do
      @batch.iterate_input_rows
      expect(Person.first.first_name).to eq "Matt"
      expect(Person.count).to eq 3
    end
    it "finishes batch, skipping missing email row" do
      batch = create_batch_from_fixture 'batch_intake_mock_data__missing_email.csv'
      batch.iterate_input_rows
      expect(Person.count).to eq 2
    end
    it "finishes batch, skipping duplicate email row" do
      batch = create_batch_from_fixture 'batch_intake_mock_data__duplicate_email.csv'
      batch.iterate_input_rows
      expect(Person.count).to eq 2
    end
    it "doesn't invalid headers excepting when a header doesn't match acceptable param for person" do
      batch = create_batch_from_fixture 'batch_intake_mock_data__invalid_headers.csv'
      batch.iterate_input_rows
      expect(Person.count).to eq 3
    end
  end
  describe :intake do
    it 'does not break when there are non-asccii chars in the file' do
      b = create_batch_from_fixture 'conversion_error.csv'
      b.intake
    end
    it "happy path" do
      expect(IntakeBatch.count).to eql 1
      @batch.intake
      expect(Person.first.first_name).to eq "Matt"
      expect(Person.count).to eq 3
      expect(IntakeBatch.find(@batch.id).status).to eq IntakeBatch::STATUS_DONE
    end
  end
  describe :intake_all_not_done do
    it 'intake_all_not_done' do
      create_batch_from_fixture'batch_intake_mock_data.csv'
      create_batch_from_fixture'batch_intake_mock_data.csv'
      create_batch_from_fixture'batch_intake_mock_data.csv'
      IntakeBatch.intake_all_not_done
      #there are four because 3 created here and one in :before_all
      expect(IntakeBatch.where('status=?', IntakeBatch::STATUS_DONE).size).to eql 4
    end
    #todo test case when batch intakes fail.
  end
end

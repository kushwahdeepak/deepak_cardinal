require 'rails_helper'
include ActionView::Helpers::TextHelper
include IncomingMailsHelper
RSpec.describe IncomingMail, type: :model do

  before :all do
    @email = File.read(Rails.root.join 'spec/fixtures/incoming_mails/email.txt')
  end

  describe 'persist_submission' do
    it 'initalizes association with submission' do
      incoming_mail = IncomingMail.create!({})
      incoming_mail.persist_submission
      expect(incoming_mail.submission).not_to be nil
      expect(incoming_mail.submission.incoming_mail.id).to eq incoming_mail.id
    end
  end


  describe 'parsed_mail' do
    it 'works' do
      incoming_mail = IncomingMail.create!({} )
      incoming_mail.parsed_mail = {'a'=>123}
      incoming_mail.save!
      incoming_mail.reload
      expect(incoming_mail.parsed_mail['a']).to eq 123
    end
  end

  describe 'parse_plain_into_parsed_mail' do
    it 'works' do
      incoming_mail = IncomingMail.create!(plain: File.read('spec/fixtures/incoming_mails/plain.txt'))
      incoming_mail.subject = "[2] from Danielle Wheeler"
      incoming_mail.parse_plain_into_parsed_mail
      incoming_mail.reload
      expect(incoming_mail.parsed_mail['name']).to eq 'Danielle Wheeler'
      expect(incoming_mail.parsed_mail['Education']).to include 'Ohio State University'

    end
  end

  describe 'persist_candidate_from_email_and_parsed_mail' do
    context 'incoming has email; candidate with email already exists in db' do
      it 'updates the existing candidate' do

        pp ={
          'Skills matching your job' => 'skills123',
          'name' =>  'joe h shmo'
        }
        incoming_mail = IncomingMail.create!({} )
        incoming_mail.candidate_email = 'joe@shmo.com'
        incoming_mail.parsed_mail = pp
        incoming_mail.save!

        existing_person = Person.create!(email_address: 'joe@shmo.com')

        incoming_mail.persist_candidate_from_email_and_parsed_mail
        existing_person.reload

        expect(existing_person.first_name).to eq 'joe'
        expect(existing_person.last_name).to eq 'shmo'
        expect(existing_person.skills).to eq 'skills123'
      end
    end
  end #describe 'persist_candidate_from_email_and_parsed_mail' do

  describe "create!" do
    it "attaches a resume" do
      file = fixture_file_upload(Rails.root.join('spec/fixtures', 'resume.doc'), 'application/msword')
      incoming_mail = IncomingMail.create!({attachment:file} )
      expect(incoming_mail.file_type_from_blob).to eq '.doc'
      expect(incoming_mail.attachment.attached?).to be true
    end
    it "saves all the attributes" do
        input = {
          "plain"=>"plain",
          "subject"=>"subj",
          "date"=>"Sun, 19 Jul 2020 19:46:46 -0700"
        }
      from_db = IncomingMail.create!(input)
      expect(from_db.plain).not_to be nil
      expect(from_db.subject).not_to be nil
      expect(from_db.date).not_to be nil
    end

  end #describe "create!" do

  describe 'pdfreader' do
    it 'owrks' do

    end
  end
end

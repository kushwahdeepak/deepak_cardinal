require 'rails_helper'

RSpec.describe EmailSequence, type: :model do
  describe 'Table structure' do
    it { is_expected.to have_db_column(:subject).of_type(:string) }
    it { is_expected.to have_db_column(:email_body).of_type(:text) }
    it { is_expected.to have_db_column(:sent_at).of_type(:datetime) }
    it { is_expected.to belong_to(:job) }
  end

  describe 'validates' do
    it 'subject to be present' do is_expected.to validate_presence_of(:subject) end
    it 'email_body to be present' do is_expected.to validate_presence_of(:email_body) end
    it 'sent_at to be present' do is_expected.to validate_presence_of(:sent_at) end
  end

  describe 'EmailSequence' do
    context 'with invalid attributes' do
      let(:job) { create(:job) }
      it 'when subject is blank' do
        email_sequence = EmailSequence.create( subject: '', email_body: 'your interview scheduled', sequence: 'email1', sent_at: DateTime.new(2001, 2, 4, 0, 0, 0, '+24:00'), job_id: job.id)
        expect(email_sequence).not_to be_valid
      end
      it 'when email_body is balck' do
        email_sequence = EmailSequence.create( subject: 'Invitation', email_body: '', sequence: 'email1', sent_at: DateTime.new(2001, 2, 4, 0, 0, 0, '+24:00'), job_id: job.id)
        expect(email_sequence).not_to be_valid
      end
      it 'when sent_at is balck' do
        email_sequence = EmailSequence.create( subject: 'Invitation', email_body: 'your interview scheduled', sequence: 'email1', sent_at: '', job_id: job.id)
        expect(email_sequence).not_to be_valid
      end

      it 'when sequence is blank' do
        email_sequence = EmailSequence.create( subject: 'Invitation', email_body: 'your interview scheduled', sequence: '', sent_at: DateTime.new(2001, 2, 4, 0, 0, 0, '+24:00'), job_id: job.id)
        expect(email_sequence).not_to be_valid
      end
    end
    context 'with valid params' do
      let(:job) { create(:job) }
      it 'successfully created' do
        email_sequence = EmailSequence.create(subject: 'Invitation', email_body: 'your interview scheduled', sequence: 'email1', sent_at: DateTime.new(2001, 2, 4, 0, 0, 0, '+24:00'), job_id: job.id)
        expect(email_sequence).to be_valid
      end
    end
  end
end

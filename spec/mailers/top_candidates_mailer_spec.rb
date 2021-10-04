require "rails_helper"

RSpec.describe TopCandidatesMailer, type: :mailer do

  before(:each) do
    Mail::TestMailer.deliveries.clear
  end

  describe 'creates mail' do
    it 'generates and send spreedsheet file' do
      csv = ExportCandidatesService.new.call
      mail = TopCandidatesMailer.csv_email(csv).deliver_now
      expect(mail.subject).to include 'Top 20 percents candidates that have applied to jobs in last week.'
      attachment = mail.attachments[0]
      expect(attachment.filename).to eq('top_candidates.csv')
      assert_emails 1
    end
  end
end

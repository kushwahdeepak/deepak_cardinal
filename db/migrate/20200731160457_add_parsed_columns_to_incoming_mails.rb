class AddParsedColumnsToIncomingMails < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :candidate_email, :string
    add_column :incoming_mails, :parsed_mail_json, :text
    add_column :incoming_mails, :parsed_job_id, :integer
  end
end

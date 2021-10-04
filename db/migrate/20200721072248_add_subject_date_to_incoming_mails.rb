class AddSubjectDateToIncomingMails < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :subject, :string
    add_column :incoming_mails, :date, :date
  end
end

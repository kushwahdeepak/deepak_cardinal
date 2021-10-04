class AddTesumeTextToIncomingMails < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :resume_text, :text
  end
end

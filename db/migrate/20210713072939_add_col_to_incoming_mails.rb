class AddColToIncomingMails < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :to, :string
    add_column :incoming_mails, :remote_ip, :string
    add_column :incoming_mails, :attachment_url, :string
  end
end

class AddColumnsToIncomingMail < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :reply, :text
    add_column :incoming_mails, :from, :string
  end
end

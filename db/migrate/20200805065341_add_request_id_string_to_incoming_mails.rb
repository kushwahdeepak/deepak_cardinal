class AddRequestIdStringToIncomingMails < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :request_id, :string
  end
end

class RemoveHtmlColumnFromIncomingMail < ActiveRecord::Migration[5.2]
  def change
    remove_column :incoming_mails, :html
  end
end

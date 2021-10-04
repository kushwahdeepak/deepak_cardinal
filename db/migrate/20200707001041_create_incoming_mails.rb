class CreateIncomingMails < ActiveRecord::Migration[5.2]
  def change
    create_table :incoming_mails do |t|
      t.text :plain
      t.text :html

      t.timestamps
    end
  end
end

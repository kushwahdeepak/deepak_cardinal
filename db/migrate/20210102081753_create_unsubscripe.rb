class CreateUnsubscripe < ActiveRecord::Migration[5.2]
  def change
    create_table :unsubscribes, id: :uuid do |t|
      t.string :email

      t.timestamps
    end
  end
end

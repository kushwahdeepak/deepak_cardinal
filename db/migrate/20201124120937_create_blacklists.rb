class CreateBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :blacklists, id: :uuid do |t|
      t.references :person, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

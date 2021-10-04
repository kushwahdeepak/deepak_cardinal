class CreateLookups < ActiveRecord::Migration[5.2]
  def change
    create_table :lookups, id: :serial, force: :cascade do |t|
      t.string :name
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :lookups, [:name]
  end
end
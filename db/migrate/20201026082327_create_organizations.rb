class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

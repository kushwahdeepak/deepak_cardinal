class CreateSignUpContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :sign_up_contracts, id: :serial, force: :cascade do |t|
      t.string :name
      t.string :role
      t.string :content

      t.timestamps
    end

    add_index :sign_up_contracts, [:role]
  end
end
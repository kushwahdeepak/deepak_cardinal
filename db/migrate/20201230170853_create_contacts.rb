class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, id: :uuid do |t|
      t.references :user, null: false
      t.integer :target_user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :street
      t.string :city
      t.string :region
      t.string :country
      t.string :postal_code
      t.string :company
      t.string :source
      t.string :job_title
      t.string :dob
      t.string :full_address


      t.timestamps
    end

    add_index :contacts, [:email, :phone_number]
  end
end

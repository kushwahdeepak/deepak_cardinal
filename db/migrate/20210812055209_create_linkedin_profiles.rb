class CreateLinkedinProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :linkedinprofiles, id: :uuid do |t|
      t.string :profile_url, null: true
      t.integer :user_id, null: true
      t.boolean :status, default: false
      t.integer :people_id, null: true
    end
  end
end

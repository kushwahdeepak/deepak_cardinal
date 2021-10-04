class LinkedInAllowImportProfile < ActiveRecord::Migration[5.2]
  def up
    create_table :linkedin_allow_import_profile, id: :integer do |t|
      t.string :email
      t.timestamps
    end
  end

  def down
    drop_table :linkedin_allow_import_profile
  end
end

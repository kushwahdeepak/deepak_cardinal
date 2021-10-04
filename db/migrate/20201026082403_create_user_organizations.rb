class CreateUserOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_organizations, id: :uuid do |t|
      t.references :user, foreign_key: true
      t.references :organization, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end

class RevampOrganization < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations, id: :uuid do |t|
      t.references :organization, type: :uuid, foreign_key: true
      t.references :inviting_user, index: true, foreign_key: {to_table: :users}
      t.references :invited_user, index: true, foreign_key: {to_table: :users}
      t.string :status

      t.timestamps
    end

    drop_table :user_organizations

    add_column :organizations, :description, :string
    add_column :organizations, :status, :string
    add_column :users, :organization_id, :uuid, foreign_key: true
    add_column :jobs, :organization_id, :uuid, foreign_key: true

    rename_column :jobs, :user_id, :creator_id
  end
end

class AddOrganizationToPerson < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :people, :organization_id
      add_column :people, :organization_id, :uuid, foreign_key: true
    end
  end
end

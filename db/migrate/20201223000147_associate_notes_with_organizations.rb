class AssociateNotesWithOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :organization_id, :string
  end
end

class AddParentIdToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :member_organization_id, :integer
  end
end

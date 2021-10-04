class AddIsDeleteToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :is_deleted, :boolean, default: false
  end
end

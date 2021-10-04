class AddNewColumnsToOrganization < ActiveRecord::Migration[5.2]
  def change
    # add_column :organizations, :industry, :string, default: ''
    add_column :organizations, :min_size, :integer, default: 1
    add_column :organizations, :max_size, :integer, default: 0
    add_column :organizations, :country, :string, default: ''
    add_column :organizations, :state, :string, default: ''
    add_column :organizations, :city, :string, default: ''
  end
end

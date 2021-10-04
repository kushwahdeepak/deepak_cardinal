class AddImageUrlOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :image_url, :text
    add_column :organizations, :file_name, :string
    add_index :organizations, :image_url
  end
end
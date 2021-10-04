class AddWebsiteUrlOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :website_url, :string

  end
end

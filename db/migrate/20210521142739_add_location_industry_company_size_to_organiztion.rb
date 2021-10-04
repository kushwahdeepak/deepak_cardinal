class AddLocationIndustryCompanySizeToOrganiztion < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :company_size, :integer
    add_column :organizations, :location, :string
    add_column :organizations, :industry, :string
  end
end

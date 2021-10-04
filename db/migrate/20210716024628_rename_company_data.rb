class RenameCompanyData < ActiveRecord::Migration[5.2]
  def change
    rename_table :company_data, :company_profiles
  end
end

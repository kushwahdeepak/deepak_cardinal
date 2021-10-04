class AddExtraFieldsJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :company_names, :text
    add_column :jobs, :school_names, :text
    add_column :jobs, :experience_years, :integer
  end
end

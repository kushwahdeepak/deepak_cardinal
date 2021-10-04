class AddFieldsToJobSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :job_searches, :keyword, :string
    add_column :job_searches, :company_names, :text
    add_column :job_searches, :school_names, :text
    add_column :job_searches, :title, :string
    add_column :job_searches, :experience_years, :integer
  end
end

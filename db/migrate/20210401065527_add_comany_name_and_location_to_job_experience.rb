class AddComanyNameAndLocationToJobExperience < ActiveRecord::Migration[5.2]
  def change
    add_column :job_experiences, :company_name, :string
    add_column :job_experiences, :location, :string
  end
end

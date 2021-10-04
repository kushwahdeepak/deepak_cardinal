class AddPresentToJobExperience < ActiveRecord::Migration[5.2]
  def change
    add_column :job_experiences, :present, :boolean, default: false
  end
end

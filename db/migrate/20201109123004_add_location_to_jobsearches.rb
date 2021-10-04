class AddLocationToJobsearches < ActiveRecord::Migration[5.2]
  def change
    add_column :job_searches, :portalcity, :string
  end
end

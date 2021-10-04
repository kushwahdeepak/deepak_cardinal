class AddLocationFieldsToJobSearch < ActiveRecord::Migration[5.2]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :country
      t.string :state
      t.string :city

      t.timestamps
    end

    rename_column :job_searches, :portalcity, :locations

    remove_column :jobs, :portalcountryid
    remove_column :jobs, :portalstate
    remove_column :jobs, :portalzip

    create_table :jobs_locations, id: :uuid do |t|
      t.uuid :location_id
      t.integer :job_id
    end
  end
end

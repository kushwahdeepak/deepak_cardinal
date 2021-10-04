class ChangeJobLocationDatatype < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs_locations, :location, :integer
    remove_column :jobs_locations, :location_id
    rename_column :jobs_locations, :location, :location_id
  end
end

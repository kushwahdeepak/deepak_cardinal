class AddJobIdToPeopleSearch < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :job_id, :integer
  end
end

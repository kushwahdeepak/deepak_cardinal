class AddAppliedToAllJobsToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :applied_to_all_jobs, :datetime
  end
end

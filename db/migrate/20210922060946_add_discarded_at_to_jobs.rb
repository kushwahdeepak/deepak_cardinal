class AddDiscardedAtToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :discarded_at, :datetime
    add_index :jobs, :discarded_at
  end
end

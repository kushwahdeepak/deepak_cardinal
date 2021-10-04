class MigrateIntakeBatchFromUuidToId < ActiveRecord::Migration[5.2]
  def change
    remove_column :intake_batches, :id
    add_column :intake_batches, :id, :primary_key
  end
end

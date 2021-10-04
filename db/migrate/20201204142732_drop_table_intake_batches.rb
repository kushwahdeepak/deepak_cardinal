class DropTableIntakeBatches < ActiveRecord::Migration[5.2]
  def change
    drop_table :intake_batches
  end
end

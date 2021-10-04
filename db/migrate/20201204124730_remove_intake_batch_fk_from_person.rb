class RemoveIntakeBatchFkFromPerson < ActiveRecord::Migration[5.2]
  def change
    if foreign_key_exists?(:people, :intake_batches)
      remove_foreign_key :people, :intake_batches
    end
  end
end
class AddCollectorIdPersonTable < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :collector_id, :integer, default: false
  end
end

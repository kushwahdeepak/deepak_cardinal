class AddReasonToUnsubscribe < ActiveRecord::Migration[5.2]
  def change
    add_column :unsubscribes, :reason, :string
  end
end

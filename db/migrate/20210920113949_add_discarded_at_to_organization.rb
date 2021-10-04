class AddDiscardedAtToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :discarded_at, :datetime
    add_index :organizations, :discarded_at
  end
end

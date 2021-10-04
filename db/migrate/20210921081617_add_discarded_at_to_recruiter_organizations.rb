class AddDiscardedAtToRecruiterOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :recruiter_organizations, :discarded_at, :datetime
    add_index :recruiter_organizations, :discarded_at
  end
end

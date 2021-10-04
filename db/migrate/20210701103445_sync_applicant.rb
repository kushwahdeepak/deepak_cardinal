class SyncApplicant < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_applicant, id: :serial, force: :cascade do |t|
      t.integer :user_id
      t.date :sync_date
      t.timestamps
    end

  end
end

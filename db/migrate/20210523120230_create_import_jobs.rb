class CreateImportJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :import_jobs do |t|
      t.uuid :organization_id
      t.string :company_name
      t.string :notificationemails
      t.string :status, default: "not done", null: false
      t.bigint :user_id, null: false
      t.text :log
    end
  end
end

class CreateEmployerDashboard < ActiveRecord::Migration[5.2]
  def change
    create_table :employer_dashboard, id: :serial, force: :cascade do |t|
      t.references  :organization, type: :uuid
      t.references  :job, null: false
      t.integer     :leads
      t.integer     :applicant
      t.integer     :recruitor_screen
      t.integer     :first_interview
      t.integer     :second_interview
      t.integer     :offer
      t.integer     :archived

      t.timestamps
    end

    add_index :employer_dashboard, [:organization_id, :job_id]
  end
end

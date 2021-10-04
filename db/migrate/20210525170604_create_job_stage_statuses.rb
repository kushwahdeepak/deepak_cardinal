class CreateJobStageStatuses < ActiveRecord::Migration[5.2]

  def change
    create_table :job_stage_statuses do |t|
      t.belongs_to :job
      t.belongs_to :user
      t.belongs_to :organization
      t.integer :leads
      t.integer :applicant
      t.integer :recruiter
      t.integer :first_interview
      t.integer :second_interview
      t.integer :offer
      t.integer :archived
      t.timestamps
    end
  end
end

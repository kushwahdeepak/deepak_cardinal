class AddColumnJobPeopleUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :linkedin_job_id, :bigint, default: 0
    add_column :users, :sync_job, :boolean, default: false
    add_column :people, :linkedin_applicant_id, :bigint, default: 0
    
  end
end

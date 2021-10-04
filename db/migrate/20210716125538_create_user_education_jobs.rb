class CreateUserEducationJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_education_jobs, id: :uuid do |t|
      t.integer :user_education_id
      t.integer :job_id

      t.timestamps
    end
  end
end

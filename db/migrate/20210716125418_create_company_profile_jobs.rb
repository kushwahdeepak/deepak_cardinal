class CreateCompanyProfileJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :company_profile_jobs, id: :uuid do |t|
      t.integer :company_profile_id
      t.integer :job_id

      t.timestamps
    end
  end
end

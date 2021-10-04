class RemoveJobExpConstraints < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      ALTER TABLE job_experiences
        DROP CONSTRAINT for_job_exp_upsert;
    SQL

    execute <<-SQL
      ALTER TABLE job_experiences
        ADD CONSTRAINT for_job_exp_upsert UNIQUE (title, company_name, location, present, person_id);
    SQL
  end
end

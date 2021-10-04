class AddConstraintForCandidateUpload < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      ALTER TABLE phone_numbers
        ADD CONSTRAINT for_upsert UNIQUE (value, phone_type);
    SQL

    execute <<-SQL
      ALTER TABLE email_addresses
        ADD CONSTRAINT for_email_upsert UNIQUE (email, email_type);
    SQL

    execute <<-SQL
      ALTER TABLE job_experiences
        ADD CONSTRAINT for_job_exp_upsert UNIQUE (title, company_name, location, present);
    SQL

    add_index :education_experiences, [:school_name, :from, :to, :person_id], unique: true, name: 'for_edu_upsert'
  end
end

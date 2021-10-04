class RemoveConstraintCandidates < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      ALTER TABLE phone_numbers
        DROP CONSTRAINT for_upsert;
    SQL

    add_index :phone_numbers, [:value, :phone_type, :person_id], unique: true

    execute <<-SQL
      ALTER TABLE email_addresses
        DROP CONSTRAINT for_email_upsert;
    SQL

    add_index :email_addresses, [:email, :email_type, :person_id], unique: true

    execute <<-SQL
      ALTER TABLE job_experiences
      DROP CONSTRAINT for_job_exp_upsert;
    SQL

    add_index :job_experiences, [:title, :company_name, :location, :person_id], unique: true, name: 'index_job_experiences_on_title_and_company_person'
  end
end
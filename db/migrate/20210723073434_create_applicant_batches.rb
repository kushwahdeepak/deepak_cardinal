class CreateApplicantBatches < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.data_source_exists? 'applicant_batches'
      create_table :applicant_batches do |t|
        t.string :model_klass
        t.integer :ok_count, default: 0, null: false
        t.integer :err_count, default: 0, null: false
        t.string :code_version
        t.string :status, default: 'not done', null: false
        t.bigint :user_id
        t.text :log
        t.references :organization
        t.references :job

        t.timestamps
      end
    end  
  end
end

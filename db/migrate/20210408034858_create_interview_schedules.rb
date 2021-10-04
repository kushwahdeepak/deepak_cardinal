class CreateInterviewSchedules < ActiveRecord::Migration[5.2]
  def change
    return if ActiveRecord::Base.connection.table_exists?('interview_schedules')
    create_table :interview_schedules, id: :uuid do |t|
      t.integer :interview_date
      t.text :description
      t.integer :person_id
      t.integer :interviewer_ids,array: true,default: []
      t.integer :interview_type
      t.references :job, foreign_key: true

      t.timestamps
    end
  end
end

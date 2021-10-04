class CreateResumeGrade < ActiveRecord::Migration[5.2]
  def change
    create_table :resume_grades, id: :uuid do |t|
      t.integer :job_id
      t.integer :person_id
      t.integer :resume_grade
    end
  end
end

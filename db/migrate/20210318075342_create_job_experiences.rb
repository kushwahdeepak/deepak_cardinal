class CreateJobExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :job_experiences, id: :uuid do |t|
      t.string :title
      t.text   :description
      t.date   :start_date
      t.date   :end_date
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end

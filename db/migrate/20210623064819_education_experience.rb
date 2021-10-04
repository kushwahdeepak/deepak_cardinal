class EducationExperience < ActiveRecord::Migration[5.2]
  def change
    create_table :education_experiences, force: :cascade do |t|
      t.string :school_name, default: '', null: false
      t.integer :from
      t.integer :to
      t.string :degree, default: ''
      t.string :major, default: ''
      
      t.timestamps
    end
    add_reference :education_experiences, :person, foreign_key: true
  end
end

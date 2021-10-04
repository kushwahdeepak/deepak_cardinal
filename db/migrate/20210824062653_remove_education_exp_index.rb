class RemoveEducationExpIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :education_experiences, name: 'for_edu_upsert', if_exists: true
    add_index :education_experiences, [:school_name, :person_id], unique: true, name: 'for_edu_upsert'
  end
end

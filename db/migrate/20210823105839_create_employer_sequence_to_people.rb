class CreateEmployerSequenceToPeople < ActiveRecord::Migration[5.2]
  def up
    create_table :employer_sequence_to_people, id: :uuid do |t|
      t.references :person, foreign_key: true
      t.references :email_sequence, foreign_key: true,  type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :employer_sequence_to_people
  end
end

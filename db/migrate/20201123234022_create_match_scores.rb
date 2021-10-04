class CreateMatchScores < ActiveRecord::Migration[5.2]
  def change
    create_table :match_scores, id: :uuid do |t|
      t.integer :job_id, null: false
      t.integer :person_id, null: false
      t.float :score, null: false

      t.timestamps
    end

    add_index(:match_scores, :job_id)
    add_index(:match_scores, :person_id)
  end
end

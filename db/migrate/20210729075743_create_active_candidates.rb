class CreateActiveCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :active_candidates, id: :uuid do |t|
      t.references :person
      t.references :job
      t.integer :candidate_match_Score, default: 0
      t.timestamps
    end
  end
end

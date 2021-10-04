class CreateMatchScoreStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :match_score_statuses, id: :uuid do |t|
      t.references :person
      t.integer :status

      t.timestamps
    end
  end
end

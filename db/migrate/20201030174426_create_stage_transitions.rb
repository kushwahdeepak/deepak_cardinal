class CreateStageTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :stage_transitions do |t|
      t.text :feedback
      t.string :stage, null: false
      t.integer :submission_id, null: false

      t.timestamps
    end
  end
end

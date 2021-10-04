class AddIndexToStageTransitionOnSubmissionId < ActiveRecord::Migration[5.2]
  def change
    add_index :stage_transitions, :submission_id
  end
end

class AddnewColumnActiveCandidate < ActiveRecord::Migration[5.2]
  def change
    add_column :job_stage_statuses, :active_candidates, :integer, default: 0
  end
end

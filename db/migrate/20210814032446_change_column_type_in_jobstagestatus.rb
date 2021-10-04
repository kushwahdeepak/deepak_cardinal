class ChangeColumnTypeInJobstagestatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_stage_statuses, :organization_id
    add_column :job_stage_statuses, :organization_id, :uuid
  end
end

class AddColumnInterviewScheduleTbale < ActiveRecord::Migration[5.2]
  def change
    add_column :interview_schedules, :organization_id, :integer
  end
end

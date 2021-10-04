class RenameScheduleInterviewcolumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :interview_schedules, :user_id, :scheduler_id
  end
end

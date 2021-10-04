class ChangeInterviewFeedbackColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :interview_feedbacks, :interview_schedule, :uuid
    remove_column :interview_feedbacks, :interview_schedule_id
    rename_column :interview_feedbacks, :interview_schedule, :interview_schedule_id
  end
end

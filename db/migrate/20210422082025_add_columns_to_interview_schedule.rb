class AddColumnsToInterviewSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :interview_schedules, :send_email, :boolean, default: false
    add_column :interview_schedules, :send_invite_link, :boolean, default: false
    add_column :interview_schedules, :interview_time, :json
    add_column :interview_schedules, :interviewers, :json
  end
end

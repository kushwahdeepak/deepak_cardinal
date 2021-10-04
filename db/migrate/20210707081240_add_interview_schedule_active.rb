class AddInterviewScheduleActive < ActiveRecord::Migration[5.2]
  def change
    add_column :interview_schedules, :active, :boolean, default: true
    InterviewSchedule.where(interview_date: nil)&.update_all(active: false)
  end
end

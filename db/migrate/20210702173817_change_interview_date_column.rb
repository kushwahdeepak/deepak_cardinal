class ChangeInterviewDateColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :interview_schedules, :interview_date
    add_column :interview_schedules, :interview_date, :date
  end
end

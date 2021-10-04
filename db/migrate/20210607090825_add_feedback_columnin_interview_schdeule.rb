class AddFeedbackColumninInterviewSchdeule < ActiveRecord::Migration[5.2]
  def change
    add_column :interview_schedules, :feedback, :string
  end
end

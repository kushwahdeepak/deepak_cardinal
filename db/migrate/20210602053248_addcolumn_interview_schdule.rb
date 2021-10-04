class AddcolumnInterviewSchdule < ActiveRecord::Migration[5.2]
  def change
    add_reference :interview_schedules, :user, foreign_key: true
  end
end

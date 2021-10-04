class CreateInterviewFeedbacks < ActiveRecord::Migration[5.2]
  def change
    remove_column :interview_schedules, :feedback
    create_table :interview_feedbacks do |t|
      t.belongs_to :user
      t.belongs_to :interview_schedule
      t.string :feedback
      t.timestamps
    end
  end
end
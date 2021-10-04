class ChangeInterviewerIdsToBeIntegerArrayInInterviewSchedules < ActiveRecord::Migration[5.2]
  def change
    change_column :interview_schedules, :interviewer_ids, :integer, array: true, default: [], using: 'ARRAY[interviewer_ids]::INTEGER[]'
  end
end

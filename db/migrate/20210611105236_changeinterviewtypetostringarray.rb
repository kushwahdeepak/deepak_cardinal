class Changeinterviewtypetostringarray < ActiveRecord::Migration[5.2]
  def change
    change_column :interview_schedules, :interview_type, :string
  end
end

class Addstagetopeople < ActiveRecord::Migration[5.2]
  def change
    SubmittedCandidateInfo.recreate_sql
  end
end

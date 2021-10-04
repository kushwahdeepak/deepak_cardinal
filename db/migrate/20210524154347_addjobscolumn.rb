class Addjobscolumn < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :nice_to_have_skills, :string
    add_column :jobs, :nice_to_have_keywords, :string
    add_column :jobs, :keywords, :string
    add_column :jobs, :notificationemails, :string
  end
end

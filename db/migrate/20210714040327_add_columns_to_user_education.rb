class AddColumnsToUserEducation < ActiveRecord::Migration[5.2]
  def change
    add_column :user_educations, :rank, :integer
    add_column :user_educations, :name, :string
    add_column :user_educations, :town, :string
  end
end

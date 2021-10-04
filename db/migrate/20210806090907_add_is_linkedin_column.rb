class AddIsLinkedinColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :is_linkedin, :boolean, default: false
  end
end

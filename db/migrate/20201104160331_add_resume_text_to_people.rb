class AddResumeTextToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :resume_text, :text
  end
end

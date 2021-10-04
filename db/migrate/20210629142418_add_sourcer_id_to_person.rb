class AddSourcerIdToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :sourcer_id, :integer
  end
end

class AddSourceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :source, :string
  end
end

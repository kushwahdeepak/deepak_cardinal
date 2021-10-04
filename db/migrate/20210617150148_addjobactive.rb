class Addjobactive < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :active, :boolean, default: true
  end
end

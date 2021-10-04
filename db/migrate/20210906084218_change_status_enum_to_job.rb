class ChangeStatusEnumToJob < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :status
    add_column :jobs, :status, :integer, default: 0
  end
end
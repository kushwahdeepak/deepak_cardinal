class AddAutoScrollToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auto_scroll, :boolean, default: false
  end
end

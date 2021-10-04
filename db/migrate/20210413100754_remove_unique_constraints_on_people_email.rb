class RemoveUniqueConstraintsOnPeopleEmail < ActiveRecord::Migration[5.2]
  def change
    remove_index :people, :email_address
    add_index :people, :email_address
  end
end

# add uniqe db level constraint on person user_id
# to ensure user only have one person .

class AddUniqueConstraintToPerson < ActiveRecord::Migration[5.2]
  def change
    # remove_index :people, :user_id # remove existing index on user id
    # add_index :people, :user_id, unique: true
  end
end

class AddMentionIdsToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :mention_ids, :integer, array: true, default: []
  end
end

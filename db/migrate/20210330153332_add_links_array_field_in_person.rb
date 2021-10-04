class AddLinksArrayFieldInPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :links, :text
    add_index :people, :links, name: 'index_by_links'
  end
end

class CreateDynamicPageContents < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?('dynamic_page_contents')
      create_table :dynamic_page_contents, id: :uuid do |t|
        t.string :name
        t.text :content
  
        t.timestamps
      end
    end
  end

  def down
    drop_table :dynamic_page_contents
  end
end
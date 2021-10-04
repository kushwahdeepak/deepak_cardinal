class CreateSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    create_table :system_configurations, id: :uuid do |t|
      t.string :name
      t.integer :value, :default => 0
    end  
  end
end

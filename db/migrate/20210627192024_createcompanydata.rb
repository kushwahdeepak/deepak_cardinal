class Createcompanydata < ActiveRecord::Migration[5.2]
  def change
    create_table :company_data do |t|
      t.string :company_name
    end
  end
end

class AddTypeToPhoneNumber < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :phone_type, :string
  end
end

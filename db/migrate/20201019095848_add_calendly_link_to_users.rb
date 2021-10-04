class AddCalendlyLinkToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :calendly_link, :text, default: ''
  end
end

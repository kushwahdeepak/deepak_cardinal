class AddLeadsCountToJobs < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:jobs, :leads_count)
      add_column :jobs, :leads_count, :integer, default: 0, null: false
    end
  end
end

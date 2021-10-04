class ChangeCampaignsNullableFields < ActiveRecord::Migration[5.2]
  def change
    change_column_null :campaigns, :start_date, true
    change_column_null :campaigns, :duration_days, true
  end
end

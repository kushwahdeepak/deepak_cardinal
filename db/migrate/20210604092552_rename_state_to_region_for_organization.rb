# state is colfliction with react state on FE . 
class RenameStateToRegionForOrganization < ActiveRecord::Migration[5.2]
  def change
    rename_column :organizations, :state, :region 
  end
end

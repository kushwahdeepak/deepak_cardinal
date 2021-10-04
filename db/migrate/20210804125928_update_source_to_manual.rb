class UpdateSourceToManual < ActiveRecord::Migration[5.2]
  def change
    # Update only those person record which have user record . 
    # ie: User.joins(:person).update_all(source: "manual")

    # Person.update_all(source: "manual")
  end
end

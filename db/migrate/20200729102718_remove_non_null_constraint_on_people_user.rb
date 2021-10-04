class RemoveNonNullConstraintOnPeopleUser < ActiveRecord::Migration[5.2]
  def up
    execute "alter table People alter user_id drop not null"
  end
end

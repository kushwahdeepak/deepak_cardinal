class Admin::UserBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :role
  field :full_name do |user, options| 
    "#{user.first_name} #{user.last_name}"
  end
end
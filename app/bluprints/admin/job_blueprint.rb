class Admin::JobBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :location, :skills, :created_at, :status
end
class Admin::OrganizationBlueprint < Blueprinter::Base
  identifier :id
  
  # included serialized fields
  fields :name, :owner_id, :description, :status, :company_size, :location,
         :industry, :min_size, :max_size, :country, :region, :city, :image_url,
         :website_url, :created_at, :updated_at

  view :datatable do
    association :owner, blueprint: Admin::UserBlueprint, default: {}
  end

end
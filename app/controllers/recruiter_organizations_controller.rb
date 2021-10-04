class RecruiterOrganizationsController < ApplicationController

  def recruiter_organizations
    if current_user&.role == "recruiter"
      organizations = []
      recruiter_organizations = current_user&.recruiter_organizations&.where(status: RecruiterOrganization::ACCEPTED)
      recruiter_organizations&.each do |recruiter_organization|
        organizations << Organization.find_by(id: recruiter_organization&.organization_id)
      end
    end
    render json: {recruiter_organizations: organizations&.uniq }
  end
end

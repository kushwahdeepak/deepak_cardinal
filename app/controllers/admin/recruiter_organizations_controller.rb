class Admin::RecruiterOrganizationsController < Admin::AdminsController
    include Pundit
    
    RESULTS_PER_PAGE = 25
  
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordInvalid, with: :render_error
    respond_to :html, :json

    # POST: /admin/recruiter_organizations
    def create
      if not format_recruiter_organization_params.empty? and RecruiterOrganization.create!(format_recruiter_organization_params)
        return render json: {msg: "Recruiter added successfully"},status: 200
      end
      return render json: {msg: "Invalid Email Id, plese try again"},status: 422
    end

    # DELETE: /admin/recruiter_organizations/:id
    def destroy
      recruiter_organization = RecruiterOrganization.find_by!(id: params[:id])
      if recruiter_organization.discard
        return render json: {msg: "Member has been successully removed"},status: 200
      end
      render json: {msg: "Something went wrong plese try again"},status: 422
    end
    
    private

    def recruiter_organization_params
      params.require(:recruiter_organizations).permit(:organization_id, :members)
    end

    def format_recruiter_organization_params 
      members = JSON.parse(recruiter_organization_params[:members]) || []
      unless members.empty?
        return members.map do |member|
          member['status'] = RecruiterOrganization::ACCEPTED
          member
        end
      end
      return []
    end

    def render_error
      return render json: {msg: "One of the recruiter already added to organization"},status: 422
    end
end
  
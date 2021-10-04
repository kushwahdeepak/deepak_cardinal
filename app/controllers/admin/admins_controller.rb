class Admin::AdminsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin_role
    before_action :set_user, only: [:update, :download_resume]
    # before_action :set_person, only: :update
  
  
    def index
      @information = Admins::AdminInfornationService.new.call
      @data = Admins::AdminInfoForGraphService.new.call
      @page_title = 'Admin Dashboard - CardinalTalent'
      render 'index'
    end
  
    def create
      result = Admins::CreateAdminService.new(create_params[:email]).call
      if result.present?
        render json: { message: 'Success', admin: result }, status: :ok
      else
        render json: { message: 'User is not found' }
      end
    end
  
    def update
      if @user.update(update_params)
        @user.admin.update(email: update_params[:email]) if @user.admin?
        @person = @user.person ? @user.person : @user.create_person()
        @person.update(person_params)
  
        render json: { message: 'Success', message_type: 'success' }, status: :ok
      else
        render json: { message: @user&.errors&.full_messages[0], message_type: 'failure' }
      end
    end
  
  
  
    def reference_data_management
      @page_title = 'Reference Data Management - CardinalTalent'
    end
  
   
    def download_resume
      send_data resume.download, filename: resume.filename, type: resume.content_type, disposition: "attachment"
    end
  
    private
  
    def create_params
      params.permit(:email)
    end
  
    def update_params
      params.require(:person).permit(:name, :email, :role, :linkedin_profile_url, :phone_number, :first_name, :last_name)
    end
  
    def person_params
      params.require(:person).permit(:name, :email_address, :linkedin_profile_url, :phone_number, :first_name, :last_name, :resume)
    end
  
    def set_user
      @user = User.find_by(id: params[:id])
    end
  
    def set_person
      @person = @user.person ? @user.person : @user.create_person()
    end
  
    def resume
      @user.resume
    end
  
    def check_admin_role
      unless current_user.admin?
        redirect_to '/'
      end
    end
  end
  
class RecruitersController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_user, only: [:destroy, :show]

  respond_to :json

  RESULTS_PER_PAGE = 25

  def index
    users = User.where(role: :recruiter).search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
    total_pages = users.total_pages

    render json: { users: users, total_pages: total_pages }
  end

  def pending
  	users = User.where(role: :recruiter).search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
    total_pages = users.total_pages

    render json: { users: users, total_pages: total_pages }
  end

  def approve
  end

  def reject
  end

  def show
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.destroy
      render json: { message: 'Recruiter was successfully deleted.' }, status: :ok
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(recruiter_params)
      render json: { message: 'Recruiter was successfully updated.' }, status: :ok
    end

  end
  private

  def set_user
    @user = User.where(role: :recruiter, id: params[:id]).first
  end

  def recruiter_params
    params.require(:user).permit(:email, :first_name, :last_name, :location, :phone_number)
  end 
end

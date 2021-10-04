class UserManagementsController < ApplicationController
  before_action :set_user, only: [:destroy, :show]
  before_action :authenticate_user!

  RESULTS_PER_PAGE = 25

  def index
    @page_title = 'Users Managements - CardinalTalent'
  end

  def show; end

  def get_users_and_admins
    if params[:search].present?
      users = User.search(params[:search]).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
      admins = User.admin.search(params[:search]).order('created_at DESC').paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
    else
      users = User.all.order('created_at DESC').paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
      admins = User.admin.order('created_at DESC').paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
    end

    total_pages_users = users.total_pages
    total_pages_admins = admins.total_pages

    render json: { users: users, admins: admins, total_pages_users: total_pages_users, total_pages_admins: total_pages_admins }
  end

  def destroy
    @user.destroy

    render json: { message: 'User was successfully deleted' }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end

class UserEducationsController < ApplicationController
#   before_action :set_user_education, only: [:show, :edit, :update, :destroy]

  def filter_universities
    universites = UserEducation.filter_university(params[:filter_word]).order(:name).first(300)
    render json: {filter: universites}
  end

#   # GET /user_educations
#   def index
#     @user_educations = UserEducation.all
#   end

#   # GET /user_educations/1
#   def show
#   end

#   # GET /user_educations/new
#   def new
#     @user_education = UserEducation.new
#   end

#   # GET /user_educations/1/edit
#   def edit
#   end

#   # POST /user_educations
#   def create
#     @user_education = UserEducation.new(user_education_params)

#     if @user_education.save
#       redirect_to @user_education, notice: 'User education was successfully created.'
#     else
#       render :new
#     end
#   end

#   # PATCH/PUT /user_educations/1
#   def update
#     if @user_education.update(user_education_params)
#       redirect_to @user_education, notice: 'User education was successfully updated.'
#     else
#       render :edit
#     end
#   end

#   # DELETE /user_educations/1
#   def destroy
#     @user_education.destroy
#     redirect_to user_educations_url, notice: 'User education was successfully deleted.'
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_user_education
#       @user_education = UserEducation.find(params[:id])
#     end

#     # Only allow a trusted parameter "white list" through.
#     def user_education_params
#       params.require(:user_education).permit(:user_id)
#     end
end

 class InterviewsController < ApplicationController
#   before_action :set_interview, only: [:show, :edit, :update, :destroy]
#   before_action :set_user, only: [:create, :show, :edit, :update, :destroy]
#   before_action :set_person, only: [:show]

#   # GET /interviews
#   def index
#     current_user.interviews.order('created_at DESC').paginate(page: params[:page], per_page: 5)
#   end

#   # GET /interviews/1
#   def show
#     @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
#     @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
#   end

#   # GET /interviews/new
#   def new
#     @interview = Interview.new
#   end

#   # GET /interviews/1/edit
#   def edit
#     @candidate_interviews = SubmittedCandidate.where(employer_id: current_user.id).paginate(page: params[:page], per_page: 5)
#     @latest_conversations = current_user.mailbox.conversations.page(params[:page]).per(3)
#   end

#   # POST /interviews
#   def create
#     @interview = Interview.new(interview_params)

#     @interview.schedule = IceCube::Schedule.new(interview_params[:time_start], duration: (interview_params[:time_end] - interview_params[:time_start]))
#     @interview.capacity = 2

#     if @interview.save
#       redirect_to @interview, notice: 'Interview was successfully created.'
#     else
#       render :new
#     end
#   end

#   # PATCH/PUT /interviews/1
#   def update
#     if @interview.update(interview_params)
#       redirect_to @interview, notice: 'Interview was successfully updated.'
#     else
#       render :edit
#     end
#   end

#   # DELETE /interviews/1
#   def destroy
#     @interview.destroy
#     redirect_to interviews_url, notice: 'Interview was successfully destroyed.'
#   end
    def scheduled_interviews
       @user = current_user
       @person_id = @user.id 
       @user_id=current_user.id
       @user_name=current_user.name
    end
#   private

#     def set_person
#       @person = current_user.people.first_or_initialize
#     end

#     # Use callbacks to share common setup or constraints between actions.
#     def set_interview
#       @interview = Interview.find(params[:id])
#     end

#     # Only allow a trusted parameter "white list" through.
#     def interview_params
#       params.require(:interview).permit(:name, :title, :content, :name, :price, :category)
#     end
end

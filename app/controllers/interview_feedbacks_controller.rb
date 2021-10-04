class InterviewFeedbacksController < ApplicationController
  before_action :authenticate_user!
  
  def feedbacks
    interview_feedbacks = InterviewFeedback.where(interview_schedule_id: params[:id]).order(created_at: :desc)
    render json: {success: true, msg: 'success', messageType: 'success', data: interview_feedbacks}
  end

  def create
    @feedback = InterviewFeedback.new(user_id: current_user.id, interview_schedule_id: params[:interview_schedule_id], feedback: params[:feedback] )
    if @feedback.save
      render json: {success: true, msg: 'Feedback added successfully', messageType: 'success', feedback: @feedback}, status: :ok
    else
      render json: {success: false, msg: @feedback.errors.full_messages , messageType: 'failure'}, status: :unprocessible_entity
    end
  end

  def update
    if set_interview_feedback.update(feedback: params[:feedback])
      render json: {success: true, msg: 'Feedback updated successfully', messageType: 'success', feedback: set_interview_feedback}, status: :ok
    else
      render json: {success: false, msg: set_interview_feedback.errors.full_messages , messageType: 'failure'}, status: :unprocessible_entity
    end
  end

  def destroy
    if set_interview_feedback.destroy
      render json: {success: true, msg: 'Feedback deleted successfully', messageType: 'success'}, status: :ok
    else
      render json: {success: false, msg: set_interview_feedback.errors.full_messages , messageType: 'failure'}, status: :unprocessible_entity
    end
  end

  private

  def set_interview_feedback
    feedback = InterviewFeedback.find(params[:id])
  end

end

class OnsiteInterview < ApplicationRecord
  belongs_to :user
  belongs_to :person
  belongs_to :call_sheet

  private

  def onsite_interview_params
    params.require(:onsite_interview).permit(:scheduled_time)
  end
end

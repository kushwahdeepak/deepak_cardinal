class InterviewFeedback < ApplicationRecord
  belongs_to :interview_schedule
  belongs_to :user

end

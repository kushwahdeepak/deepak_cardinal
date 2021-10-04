class SubmissionPolicy < ApplicationPolicy
  include Pundit

  def change_stage?
    Authorization.people_intake?(user)
  end

  def reject?
    Authorization.people_intake?(user)
  end

  def move_to_applicant_stage?
    Authorization.people_intake?(user) ? true : false
  end

end

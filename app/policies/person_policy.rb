class PersonPolicy < ApplicationPolicy
  include Pundit

  class Scope < Scope
    def resolve
      if user.admin? || user.member? || user.recruiter? || user.employer?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def view_candidate_contacts?
    user.admin? || user.recruiter? || user.email == record.email_address
  end

  def index?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif user.role == "employer" || record.try(:user) == user
      true
    else
      false
    end
  end

  def show?
    if user.admin? || user.member? || user.recruiter? || user.employer?
      true
    elsif record.try(:user) == user
      true
    else
      false
    end
  end

  def new?
    create?
  end

  def create?
    if user.admin? || user.member? || user.recruiter?
      true
    else
      false
    end
  end

  def update?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif record.try(:user) == user
      true
    else
      false
    end
  end

  def edit?
    update?
  end

  def destroy?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif user.role == 'employer' || record.try(:user) == user
      true
    else
      false
    end
  end
end

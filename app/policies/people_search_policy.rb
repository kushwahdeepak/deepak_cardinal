class PeopleSearchPolicy < ApplicationPolicy
  include Pundit

  def index?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif user.role == 'employer' || record.try(:user) == user
      true
    else
      false
    end
  end

  def show?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif user.role == 'employer' || record.try(:user) == user
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
    elsif user.role == 'employer' || record.try(:user) == user
      true
    else
      false
    end
  end

  def update?
    if user.admin? || user.member? || user.recruiter?
      true
    elsif user.role == 'employer' || record.try(:user) == user
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

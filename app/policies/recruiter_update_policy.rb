class RecruiterUpdatePolicy < ApplicationPolicy
  include Pundit

  # class Scope < Scope
  #   def resolve
  #     if user.admin? || user.member? || user.recruiter? || user.employer?
  #       scope.where(user: user)
  #     else
  #       false
  #     end
  #   end
  # end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end
end

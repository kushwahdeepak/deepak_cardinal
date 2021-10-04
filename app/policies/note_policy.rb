class NotePolicy < ApplicationPolicy
  include Pundit

  class Scope < Scope
    def resolve
      if user.admin? || user.member?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def index?
    if user.admin? || user.member?
      true
    elsif user.role == "employer"
      false
    else
      false
    end
  end

  def show?
    if user.admin? || user.member?
      true
    elsif user.role == "employer"
      true
    else
      false
    end
  end

  def create?
    if user.admin? || user.member?
      true
    elsif user.role == "employer"
      true
    else
      false
    end
  end

  def update?
    if user.admin? || user.member?
      true
    elsif user.role == "employer"
      false
    else
      false
    end
  end
end

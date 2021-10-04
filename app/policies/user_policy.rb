class UserPolicy < ApplicationPolicy
  include Pundit
  class Scope < Scope
    attr_reader :user, :scope

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end

    def update
      user.admin? || record.try(:user) == user
    end

    def update?
      user.admin? || record.try(:user) == user
    end

    def show?
      user.admin? || record.try(:user) == user
    end

    def dashboard?
      user.admin? || record.try(:user) == user
    end

    def read?
      user.admin? || record.try(:user) == user
    end

    def destroy?
      user.admin? || record.try(:user) == user
    end

    def finish_signup?
      user.admin? || record.try(:user) == user
    end

    def newhires?
      user.role == 'recruiter' && user.signuprole == 'recruiter'
    end
  end
end

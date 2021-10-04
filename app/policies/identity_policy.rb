class IdentityPolicy < ApplicationPolicy
  include Pundit
  class Scope < Scope
    attr_reader :identity, :scope

    def resolve
      if user.admin?
        scope.all
      else
        scope
      end
    end

    def update?
      user.admin? || record.user == user
    end
  end
end

class JobPolicy < ApplicationPolicy
  include Pundit
  class Scope < Scope
    attr_reader :user, :scope

    def resolve
      if user.admin?
        scope.all
      elsif user.role == "recruiter"
        scope.where(issyndicated: true)
      elsif user.role == "guest"
        scope.all
      else
        scope.where(user: user)
      end
    end


  end
end

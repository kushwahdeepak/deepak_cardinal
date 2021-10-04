class WelcomePolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def resolve
      true
    end

    def edit?
      update?
    end

    def index?
      true
    end

    def show?
      true
    end
  end
end

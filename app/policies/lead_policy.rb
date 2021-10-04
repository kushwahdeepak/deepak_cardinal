class LeadPolicy < ApplicationPolicy
  include Pundit

  class Scope < Scope
    attr_reader :user, :scope

    def resolve
      true
    end

    def create?
      true
    end

    def new?
      create?
    end

    def update?
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

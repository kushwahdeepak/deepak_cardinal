class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record=nil)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end


  def show?
    user.admin? || user.member? || user.recruiter? || user.employer? || user.moderator? || record.try(:user) == user
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user.admin? || record.try(:user) == user
  end

  def update
    user.admin? || record.try(:user) == user
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || user.member? || user.recruiter? || user.employer? || user.moderator? || record.try(:user) == user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def rails_admin?(action)
    case action
    when :dashboard
      user.admin?
    when :index
      user.admin?
    when :create
      user.admin?
    when :show
      user.admin?
    when :new
      user.admin?
    when :edit
      user.admin?
    when :destroy
      user.admin?
    when :export
      user.admin?
    when :history
      user.admin?
    when :show_in_app
      user.admin?
    when :update
      user.admin?
    else
      raise ::Pundit::NotDefinedError, "unable to find policy #{action} for #{record}."
    end
  end
end

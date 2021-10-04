class OrganizationPolicy < ApplicationPolicy
  include Pundit

  def update?
    if record.owner == user || user&.role == 'admin'
      true
    else
      false
    end
  end

  def edit?
    update?
  end

  def approve?
    update
  end

  def reject?
    update
  end

  def destroy?
    update?
  end
end

class ReferralPolicy < ApplicationPolicy
  include Pundit

  def create?
    Authorization.referrals_create?(user)
  end

end

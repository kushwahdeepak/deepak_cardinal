module Discardable
  module RecruiterOrganization
    def discard
      user.update(organization_id: nil)
      super
    end
  end
end
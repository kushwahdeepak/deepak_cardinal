module Discardable
  # Discard hooks for organization 
  module Organization
    def discard
      ActiveRecord::Base.transaction do
        owner.update(discarded_at: Time.current)
        jobs.update_all(discarded_at: Time.current, status: 'expired')
        recruiter_organizations.update_all(discarded_at: Time.current)
        super
      end
    end
  end
end
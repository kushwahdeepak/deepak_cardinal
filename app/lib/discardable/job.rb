module Discardable
  module Job
    # Overide hook
    def discard
      ActiveRecord::Base.transaction do
        update(active: false) # TODO: use discard only, remove it later
        interview_schedules.update_all(active: false) # use discard 
        super
      end
    end #EOF

  end
end
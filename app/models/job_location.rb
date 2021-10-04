class JobLocation < ApplicationRecord
  belongs_to :job_locatable, polymorphic: true
end

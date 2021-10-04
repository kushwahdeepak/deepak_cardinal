class SubmittedCandidate < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :user
  belongs_to :person

  validates :user, presence: true

  acts_as_followable
  acts_as_messageable

  attr_accessor :form_step

  cattr_accessor :form_steps do
    %w(user person job)
  end

  def required_for_step?(step)
    # Only the following fields are required if no form step is present
    true if form_step.nil?
    
    # All fields from previous steps are required if the step param
    # appears before or we are on the current step
    true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end
end

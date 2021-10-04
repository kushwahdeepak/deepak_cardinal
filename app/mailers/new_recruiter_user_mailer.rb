class NewRecruiterUserMailer < ApplicationMailer
  default from: "noreply@cardinaltalent.ai"

  def sample_email(user)
    @user = user
    mail(to: 'access-request@cardinalhire.com', subject: 'CardinalTalent: New Recruiter Account')
  end
end

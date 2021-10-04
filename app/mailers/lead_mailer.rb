class LeadMailer < ApplicationMailer
  default from: 'alex@cardinalhire.com'

  def welcome_email(lead)
    @lead = lead
    @url = 'https://www.cardinalhire.com/'
    mail(to: @lead.email, subject: 'CardinalTalent: Next Steps')
  end
end

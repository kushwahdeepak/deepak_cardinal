class EmployerRequestForInterviewMailer < ApplicationMailer
  default from: 'contact@cardinalhire.com'

  def new_request_to_account_manager(user, candidate)
    @user = User.find(user.id)
    @candidate = candidate.person
    mail(to: 'contact@cardinalhire.com', subject: 'CardinalTalent: Request for Interview', from: 'contact@cardinalhire.com')
  end

  # TODO:def new_request_to_employer(user, candidate)
  #   @user = User.find(user.id)
  #   @candidate = candidate.person
  #   mail(to: @user.)
  # end

  def new_request_to_candidate(user, candidate)
    @user = User.find(user.id)
    @candidate = candidate.person
    mail(to: @candidate.email_address, subject: 'CardinalTalent: You have a new request for an interview!', from: 'contact@cardinalhire.com')
  end

  def destroy_request_email(user, candidate)
    @user = User.find(user.id)
    @candidate = candidate.person
    mail(to: 'contact@cardinalhire.com', subject: 'CardinalTalent: Canceled Request for Interview', from: 'contact@cardinalhire.com')
  end

end

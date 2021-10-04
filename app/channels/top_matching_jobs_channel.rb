class TopMatchingJobsChannel < ApplicationCable::Channel
  def subscribed
     @person = Person.find_by_email(params[:email])
     stream_for @person
  end
end

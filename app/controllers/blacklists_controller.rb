class BlacklistsController < ApplicationController
  def unsubscribe
    person = Person.find(params[:person_id])
    user   = User.find(params[:user_id])
    if Blacklist.where(person: person, user: user).present?
      redirect_to root_path, notice: "You've already unsubscribed from the campaign before!"
    else
      blacklist = Blacklist.new(person: person, user: user)
      if blacklist.save(person: person, user: user)
        redirect_to root_path, notice: 'You were successfully unsubscribed from the campaign!'
      else
        redirect_to root_path, error: blacklist.errors
      end
    end
  end
end

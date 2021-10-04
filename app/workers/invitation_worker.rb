class InvitationWorker
  include Sidekiq::Worker

  def perform(contact_id)
    InvitationMailer.invitation(contact_id).deliver
  end

end

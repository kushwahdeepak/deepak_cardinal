class InvitationMailer < ApplicationMailer

  def invitation(contact_id)
    @contact = Contact.find_by(id: contact_id)
    @url = "#{ENV['HOST']}/my_connections/#{@contact.try(:id)}/invite?received_contacts=true"

    @unsubscribe_url = "#{ENV['HOST']}/my_connections/unsubscribe"

    mail to: @contact.email, subject: "Please add me to your Cardinal Talent network"
  end
end

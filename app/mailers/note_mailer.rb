class NoteMailer < ApplicationMailer
  
  def mention_id_mailer(user_email, user_notes)
    @user_email = user_email
    @user_notes = user_notes
    mail(to: @user_email, subject: 'You Have Been Mentioned in a Note')
  end   
end


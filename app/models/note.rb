# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  body       :text
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  mention_ids :integer[]

class Note < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :user, optional: true
  # after_create :send_save_emails
  after_create :send_emails_to_mentioned_users

  validates :body, presence: true

  delegate :user, to: :user, allow_nil: true, prefix: true
  delegate :email, to: :user, allow_nil: true, prefix: true

  default_scope { order('updated_at DESC') }

  def send_emails_to_mentioned_users
    mention_ids = self&.mention_ids
    users = User.where(id:mention_ids)
    users.each do |user|
      NoteMailer.mention_id_mailer(user.email, self.body).deliver_now
    end
  end

  private

  def send_save_emails
    user.saves.each do |save|
      SaveMailer.new_note(save.user, person, self).deliver_now
    end
  end

  def note_params
    params.require(:note).permit(:body, :user_id, :person_id, mention_ids: [])
  end
end

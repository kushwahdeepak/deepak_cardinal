class Contact < ApplicationRecord

  # enum status: ['Send', 'Received', 'Accepted', 'Rejected']
  enum status: [:send, :received, :accepted, :rejected], _prefix: true

  belongs_to :user
  belongs_to :target_user, class_name: 'User', foreign_key: :target_user_id, optional: true

  after_create :send_invitations

  scope :contact_status, -> (status){ where(status: status) }

  scope :received_contact_requests, -> (user_id) {
    where("target_user_id = :id AND status = :status", id: user_id, status: Contact.statuses[:send])
  }

  scope :accepted_contact_requests, -> (user_id) {
    where("(user_id = :id OR target_user_id = :id) AND status = :status", id: user_id, status: Contact.statuses[:accepted])
  }

  scope :send_contact_requests, -> (user_id) {
    where("user_id = :id AND (status = :status OR status IS NULL)", id: user_id, status: Contact.statuses[:send])
  }

  def full_name
    "#{first_name} #{last_name}" if first_name.present? || last_name.present?
  end

  def send_invitations
    if Unsubscribe.find_by(email: self.email).nil?
      #Email delivery
      InvitationWorker.perform_async(self.id)
    end
  end

  def as_json(options = {})
    super({
      only: [:email, :full_address, :job_title, :id, :user_id, :status],
      methods: [:full_name],
      include: {
        user: {
          only: [:id, :job_title, :location, :name],
        }
      }
    })
  end
end

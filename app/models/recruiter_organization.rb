class RecruiterOrganization < ApplicationRecord
  include Discard::Model
  include Discardable::RecruiterOrganization
  
  ACCEPTED = 'accepted'.freeze
  REMOVED = 'removed'.freeze

  # Associations
  belongs_to :organization
  belongs_to :user

  # Scopes
  scope :organization_members, ->(organization_id) {
    joins(:user)
    .select("
       users.first_name,
       users.last_name,
       users.email,
       users.role,
       recruiter_organizations.id,
       recruiter_organizations.user_id
     ")
     .where(organization_id: organization_id)}

     # Validations
     validate :member_already_exist, on: :create

     def member_already_exist
      if RecruiterOrganization.exists?(user_id: self.user_id, organization_id: self.organization_id, status: 'accepted')
        errors.add(:base, "already a member of organization.")
      end
     end

  default_scope -> { kept }
 
end


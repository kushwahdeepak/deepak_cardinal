module UsersHelper
  def user_has_no_people?(user)
    user.people.blank?
  end

  def user_has_no_notes?(user)
    user.notes.blank?
  end

  def user_has_no_searches?(user)
    user.searches.blank?
  end

  def user_has_no_call_sheets?(user)
    user.call_sheets.blank?
  end

  def users_for_organization(organization, is_for_owner = false)
    user_org_ids = User.joins(:organizations).where(organizations: { id: organization.id}).pluck(:id)
    user_org_ids << organization.owner.id if is_for_owner
    if organization.name.present?
      User.where(company_name: organization.name)
    else
      User.all
    end.or(User.where(id: user_org_ids)).map { |user| [user.email, user.id] }
  end

  def user_avatar_url(current_user)
    person = Person.find_by(user_id: current_user.id)
    person&.avatar_url
  end
end

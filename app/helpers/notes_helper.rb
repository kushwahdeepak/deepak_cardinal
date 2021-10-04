module NotesHelper
  def user_is_authorized_for_note?(note)
    current_user && (current_user.id == note.user_id || current_user.admin?)
  end
end

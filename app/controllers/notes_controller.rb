class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
    @user = User.find_by_id(@note.user_id)
    @person = Person.find_by_id(@note.person_id)

    unless current_user
      flash.now[:alert] = "You must be signed in to view notes."
      redirect_to new_session_path
    end
  end


  def new
    @person = Person.find(params[:id])
    @note = current_user.notes.new
  end

  def create
    @person = Person.find(params[:person_id])
    @note = Note.new(note_params)
    @note.person_id = @person.id
    @note.user_id = current_user.id
    @note.organization_id = current_user.organization_id

    unless @note.body.empty?
      if @note.save!
          redirect_back(fallback_location: root_path)
          flash[:notice] = "Successfully added note to this person."

      else
        redirect_back(fallback_location: root_path)
        flash[:error] = "There was an error saving this note. Please try again later."
      end
    end

    if @note.body.empty?
      redirect_back(fallback_location: root_path)
      flash[:error] = "Can't save a blank note."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @note = Note.find(params[:id])
    person_id = @note.person_id
    @note.destroy!

    if @note.destroy!
      redirect_to :back
      flash[:notice] = "Note was deleted."
    else
      redirect_to :back
      flash[:error] = "Note couldn't be deleted. Please try again."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :user_id, :person_id, :authenticity_token, mention_ids: [])
  end
end

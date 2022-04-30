class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
  end

  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
    @note.user = current_user
    if @note.save
      flash[:notice] = "Note saved successfully"
    redirect_to @note
    else
    render 'new'
    end
  end

  def update
    if @note.update(note_params)
      flash[:notice] = "Note updated successfully"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_path
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :description)
  end

  def require_same_user
    if current_user != @note.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own note"
      redirect_to @note
    end
  end
end

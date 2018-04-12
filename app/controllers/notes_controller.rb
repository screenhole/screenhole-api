class NotesController < ApplicationController
  before_action :authenticate_user

  def any
    notes_count = current_user.notes.where(read: false).count
    render json: { pending: notes_count }
  end

  def index
    notes = current_user.notes
    render json: notes
  end
end

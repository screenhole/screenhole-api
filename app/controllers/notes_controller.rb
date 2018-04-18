class NotesController < ApplicationController
  before_action :authenticate_user

  def any
    notes_count = current_user.notes.count

    render json: { pending: notes_count }
  end

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 25

    notes = current_user.notes.page(page).per(per_page)

    render json: notes, meta: pagination_dict(notes)
  end
end

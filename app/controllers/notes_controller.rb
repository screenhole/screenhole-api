class NotesController < ApplicationController
  before_action :authenticate_user

  def any
    s_l_r_at = current_user.sup_last_requested_at
    notes_count = current_user.notes.where('created_at >= ?', s_l_r_at).count

    render json: { pending: notes_count }
  end

  def index
    current_user.touch(:sup_last_requested_at)

    page = params[:page] || 1
    per_page = params[:per_page] || 25

    notes = Note.includes(:user, :actor, :cross_ref).where(user: current_user).page(page).per(per_page)

    render json: notes, meta: pagination_dict(notes)
  end
end

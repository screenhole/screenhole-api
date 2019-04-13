# frozen_string_literal: true

class Api::V2::NotificationsController < Api::V2::ApplicationController
  before_action :authenticate_user

  PER_PAGE = 50

  def index
    current_user.touch(:sup_last_requested_at)

    @notes = Note.includes(:user, :actor, :cross_ref)
                 .where(user: current_user)
                 .page(params[:page])
                 .per(PER_PAGE)

    render(
      json: @notes,
      meta: pagination_dict(@notes)
    )
  end
end

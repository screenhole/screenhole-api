class Api::V2::InvitationsController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[price]
  before_action :load_writable_hole, except: %i[price]

  def index
    render json: current_user.invites.where(hole: @hole)
  end

  def create
    @invite = current_user.invites.new(hole: @hole)

    if @invite.save
      render json: @invite
    else
      respond_with_errors(@invite)
    end
  end

  def price
    render json: {
      price: Buttcoin::AMOUNTS[:generate_invite].abs
    }
  end
end

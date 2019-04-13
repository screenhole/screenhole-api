class Api::V2::InvitationsController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[current_price]

  def index
    render json: current_user.invites
  end

  def create
    @invite = current_user.invites.new

    if @invite.save
      # TODO: debit buttcoin
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

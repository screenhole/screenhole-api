class InvitesController < ApplicationController
  before_action :authenticate_user, except: [:current_price]

  def index
    render json: current_user.invites
  end

  def create
    invite = current_user.invites.new

    if invite.save
      render json: invite
    else
      respond_with_errors(invite)
    end
  end

  def current_price
    render json: {
      price: Buttcoin::AMOUNTS[:generate_invite].abs
    }
  end
end

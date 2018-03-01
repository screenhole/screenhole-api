class InvitesController < ApplicationController
  before_action :authenticate_user, except: [:current_price]

  def index
    render json: current_user.invites
  end

  def create
    # check balance
    unless current_user.buttcoin_balance + Buttcoin::COSTS[:generate_invite] > 0
      return render json: {
        error: 'not enough buttcoin',
      }, status: :unprocessable_entity
    end

    invite = current_user.invites.new

    if invite.save
      current_user.buttcoin_transaction(Buttcoin::COSTS[:generate_invite], "Generated invite #{invite.hashid}")
      render json: invite
    else
      respond_with_errors(invite)
    end
  end

  def current_price
    render json: {
      price: Buttcoin::COSTS[:generate_invite].abs
    }
  end
end

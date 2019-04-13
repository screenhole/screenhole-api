class Api::V2::CurrencyController < Api::V2::ApplicationController
  before_action :authenticate_user

  def index
    @balance = ButtcoinBalance.new(
      user: current_user,
      since: 24.hours.ago
    )

    render json: @balance
  end

  def trends
    head 410
  end
end

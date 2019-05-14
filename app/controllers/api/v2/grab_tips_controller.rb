class Api::V2::GrabTipsController < Api::V2::ApplicationController
  before_action :authenticate_user
  before_action :load_writable_hole
  before_action :load_grab

  def create
    return head :forbidden unless @grab.hole == @hole

    @grab_tip = GrabTip.new(
      grab: @grab,
      user: current_user,
      amount: params[:amount]
    )

    if @grab_tip.save
      render json: @grab_tip
    else
      respond_with_errors(@grab_tip)
    end
  end

  private

  def load_grab
    @grab = Grab.find_by_hashid!(params[:grab_id])
  end
end

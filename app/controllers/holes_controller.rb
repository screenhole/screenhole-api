class HolesController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_thinko_staff
  before_action :load_hole, only: %i[show update]

  def create
    @hole = Hole.new(hole_params)

    @hole.hole_memberships << HoleMembership.new(
      user: current_user
    )

    if @hole.save
      render json: @hole
    else
      respond_with_errors(@hole)
    end
  end

  def show
    render json: @hole
  end

  def update
    if @hole.update(hole_params)
      render json: @hole
    else
      respond_with_errors(@hole)
    end
  end

  private

  def hole_params
    params.require(:hole).permit(
      :name,
      :subdomain,
      *Hole::RULES
    )
  end

  def load_hole
    @hole = Hole.find_by!(subdomain: params[:id])
  end
end

class Api::V2::HolesController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[show]
  before_action :load_readable_hole, only: %i[show]
  before_action :load_writable_hole, only: %i[update]
  before_action :ensure_hole_ownership, only: %i[update]

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

  def load_readable_hole
    @hole = Hole.find_by!(subdomain: params[:id])
  end

  def load_writable_hole
    @hole = current_user.holes.find_by!(subdomain: params[:id])
  end

  def ensure_hole_ownership
    raise ActionController::RoutingError, "You don't own that, pal" unless @hole.owner == current_user
  end
end

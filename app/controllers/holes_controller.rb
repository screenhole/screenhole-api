class HolesController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_thinko_staff

  def create
    @hole = Hole.new(hole_params)

    if @hole.save
      render json: @hole
    else
      respond_with_errors(@hole)
    end
  end

  def show
    @hole = Hole.find_by!(subdomain: params[:id])
    render json: @hole
  end

  private

  def hole_params
    params.require(:hole).permit(
      :name,
      :subdomain
    )
  end
end
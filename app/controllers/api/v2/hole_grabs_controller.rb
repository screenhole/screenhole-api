class Api::V2::HoleGrabsController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[index show]
  before_action :load_readable_hole, only: %i[index show]
  before_action :load_writable_hole, only: %i[create]

  def index
    @grabs = Grab.feed(
      page: params[:page],
      hole: @hole
    )

    render json: @grabs, meta: pagination_dict(@grabs)
  end

  def show
    @grab = Grab.find_by!(
      hashid: params[:id],
      hole: @hole
    )

    render json: @grab
  end

  def create
    @grab = current_user.grabs.new(grab_params)

    @grab.hole = @hole

    if @grab.save
      # TODO: ActionCable, Buttcoin credits
      render json: @grab
    else
      respond_with_errors(@grab)
    end
  end


  private

  def grab_params
    params.require(:grab).permit(
      :description,
      :image_path
    )
  end

  def load_readable_hole
    @hole = Hole.find_by!(subdomain: params[:hole_id])
  end

  def load_writable_hole
    @hole = current_user.holes.find_by!(subdomain: params[:hole_id])
  end
end

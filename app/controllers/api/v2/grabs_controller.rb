class Api::V2::GrabsController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[index show]
  before_action :load_readable_hole, only: %i[show]
  before_action :load_writable_hole, only: %i[create destroy]

  def index
    # Do this vs. load_writable_hole so we get nil vs. raising an exception
    @hole = Hole.from_subdomain_or_nil(params[:subdomain] || params[:hole_id])

    # If there's a specific hole requested which is private, only return
    # grabs if there's a logged in user and they're a member of that hole.
    if @hole && @hole.private_grabs_enabled? && !@hole.users.include?(current_user)
      render json: [] and return
    end

    @grabs = Grab.feed(
      page: params[:page],
      hole: @hole,
      user_id: current_user.try(:id) || params[:user_id]
    )

    render json: @grabs, meta: pagination_dict(@grabs)
  end

  def show
    @grab = Grab.find_by_hashid!(params[:id])

    head :forbidden unless @grab.hole == @hole

    render json: @grab
  end

  def create
    @grab = current_user.grabs.new(grab_params)

    @grab.hole = @hole

    if @grab.save
      render json: @grab
    else
      respond_with_errors(@grab)
    end
  end

  def destroy
    @grab = Grab.find_by_hashid!(params[:id])

    head :forbidden unless @grab.hole == @hole

    if @grab.destroy
      head :no_content
    else
      respond_with_errors(@grab)
    end
  end

  def report
    head :not_found
  end

  private

  def grab_params
    params.require(:grab).permit(
      :description,
      :image_path
    )
  end
end

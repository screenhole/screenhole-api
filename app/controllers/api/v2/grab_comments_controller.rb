class Api::V2::GrabCommentsController < Api::V2::ApplicationController
  before_action :authenticate_user
  before_action :load_writable_hole
  before_action :load_grab

  def create
    return head :forbidden unless @grab.hole == @hole

    @grab_comment = GrabComment.new(
      grab: @grab,
      user: current_user,
      message: params[:message]
    )

    if @grab_comment.save
      render json: @grab_comment
    else
      respond_with_errors(@grab_comment)
    end
  end

  private

  def load_grab
    @grab = Grab.find_by_hashid!(params[:grab_id])
  end
end

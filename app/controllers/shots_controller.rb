class ShotsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    if params[:user_id].present?
      shots = User.find(params[:user_id]).shots.all
    else
      shots = Shot.all
    end

    render json: shots.reverse_order
  end

  def show
    render json: Shot.find(params[:id])
  end

  def create
    obj = AWS_S3_BUCKET.object("#{current_user.hashid}/#{Time.now.to_i}.png")
    obj.upload_file(params[:image].tempfile, acl: 'public-read')

    shot = current_user.shots.new
    shot.image_path = obj.key

    shot.save

    ActionCable.server.broadcast "shots_messages", {
      shot: ActiveModelSerializers::SerializableResource.new(shot).as_json
    }

    render json: shot
  end

  def item_params
    params.require(:shot).permit(:image)
  end
end

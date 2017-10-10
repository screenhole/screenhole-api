class ShotsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    @shots = Shot.all

    render json: @shots
  end

  def show
    render json: Shot.all
  end

  def create
    obj = AWS_S3_BUCKET.object("#{Time.now.to_i}.png")
    obj.upload_file(params[:image].tempfile, acl: 'public-read')

    shot = current_user.shots.new
    shot.image_path = obj.key

    shot.save

    render json: shot
  end

  def item_params
    params.require(:shot).permit(:image)
  end
end

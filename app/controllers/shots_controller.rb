class ShotsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    page = params[:page]
    per_page = params[:per_page] || 25

    if params[:user_id].present?
      shots = User.find(params[:user_id]).shots.page(page).per(per_page)
    else
      shots = Shot.all.page(page).per(per_page)
    end

    shots.reverse_order!

    render json: shots, meta: pagination_dict(shots)
  end

  def show
    render json: Shot.find(params[:id])
  end

  def create
    shot = current_user.shots.new

    begin
      obj = AWS_S3_BUCKET.object("#{current_user.hashid}/#{Time.now.to_i}.png")
      obj.upload_file(params[:image].tempfile, acl: 'public-read')

      shot.image_path = obj.key
    rescue Exception => e
      logger.debug "missing params[:image].tempfile probably"
    end

    if shot.save
      ActionCable.server.broadcast "shots_messages", ActiveModelSerializers::SerializableResource.new(shot).as_json
      render json: shot
    else
      respond_with_errors(shot)
    end
  end

  def destroy
    shot = current_user.shots.find_by_hashid(params[:id])

    if shot.nil?
      render status: 400, json: {
        status: 400,
        detail: "Could not find grab"
      }
    elsif shot.destroy
      # TODO: send delete over ActionCable
      render json: {
        status: 200,
        detail: "Success"
      }
    else
      render status: 400, json: {
        status: 400,
        detail: "Could not destroy grab"
      }
    end
  end

  def item_params
    params.require(:shot).permit(:image)
  end
end

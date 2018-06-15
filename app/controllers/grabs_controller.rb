class GrabsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    page = params[:page]
    per_page = params[:per_page] || 25

    if params[:user_id].present?
      grabs = User.find(params[:user_id]).grabs.page(page).per(per_page)
    else
      blocked_users = []

      if current_user
        blocked_users = current_user.blocked
        blocked_users.map! { |x| User.decode_id x }
      end

      grabs = Grab.includes(:user, :memos).where(Grab.arel_table[:user_id].not_in blocked_users).page(page).per(per_page)
    end

    grabs.reverse_order!

    render json: grabs, meta: pagination_dict(grabs)
  end

  def show
    render json: Grab.find(params[:id]), include: [ 'user', 'memos.user' ]
  end

  def create
    grab = current_user.grabs.new

    description_limit = 500

    if params[:description].present?
      description = params[:description][0..description_limit]
      grab.description = description.gsub(/[^0-9A-z@#.\-]/, '_')
    end

    begin
      obj = AWS_S3_BUCKET.object("#{current_user.hashid}/#{Time.now.to_i}.png")
      obj.upload_file(params[:image].tempfile, acl: 'public-read')

      grab.image_path = obj.key
    rescue Exception => e
      logger.debug "missing params[:image].tempfile probably"
    end

    if grab.save
      ActionCable.server.broadcast "grabs_messages", ActiveModelSerializers::SerializableResource.new(grab).as_json
      current_user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_grab], "Created Grab #{grab.hashid}")
      render json: grab
    else
      respond_with_errors(grab)
    end
  end

  def destroy
    grab = current_user.grabs.find_by_hashid(params[:id])

    if grab.nil?
      render status: 400, json: {
        status: 400,
        detail: "Could not find grab"
      }
    elsif grab.destroy
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

  def report
    render json: {
      status: 200,
      detail: "Success"
    }
  end

  def item_params
    params.require(:grab).permit(:image, :description)
  end
end

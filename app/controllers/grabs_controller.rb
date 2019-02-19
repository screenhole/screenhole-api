class GrabsController < ApplicationController
  GRABS_FEED_CACHE_KEY = 'grabs_feed'.freeze

  before_action :authenticate_user, except: [:index, :show]

  def index
    page = params[:page]
    per_page = 25

    if params[:user_id].present?
      grabs = User.find(params[:user_id]).grabs.page(page).per(per_page).reverse_order
      render json: grabs, meta: pagination_dict(grabs)
      return
    end

    grabs_json = Rails.cache.fetch("#{GRABS_FEED_CACHE_KEY}_page_#{page}", expires_in: 1.minute) do
      grabs = Grab.includes(:user, :memos).page(page).per(per_page).reverse_order

      render_to_string(
        json: grabs,
        meta: pagination_dict(grabs)
      )
    end

    render json: grabs_json
  end

  def show
    render json: Grab.find(params[:id]), include: [ 'user', 'memos.user' ]
  end

  def create
    grab = current_user.grabs.new

    description_limit = 500

    if params[:description].present?
      description = params[:description][0..description_limit]
      sanitized = description.gsub(/[^0-9A-z@#.\-]/, 'SHReplaceMe')
      grab.description = sanitized.gsub(/SHReplaceMe/, ' ').strip
    end

    begin
      obj = if params[:type].present? && params[:type].include?('recording')
              grab.media_type = :recording
              AWS_S3_BUCKET.object("#{current_user.hashid}/#{Time.now.to_i}.mp4")
            else
              AWS_S3_BUCKET.object("#{current_user.hashid}/#{Time.now.to_i}.png")
            end

      obj.upload_file(params[:image].tempfile, acl: 'public-read')
      grab.image_path = obj.key
    rescue StandardError => e
      logger.debug 'missing params[:image].tempfile probably'
      logger.debug "uncaught #{e} exception while uploading to S3: #{e.message}"
    end

    if grab.save
      ActionCable.server.broadcast "grabs_messages", ActiveModelSerializers::SerializableResource.new(grab).as_json
      current_user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_grab], "Created Grab #{grab.hashid}")
      Rails.cache.delete_matched("#{GRABS_FEED_CACHE_KEY}*")
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
      Rails.cache.delete_matched("#{GRABS_FEED_CACHE_KEY}*")
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
    params.require(:grab).permit(:image, :description, :type)
  end

  private

  def blockees
    return @blockees if @blockees

    @blockees = []

    if current_user
      @blockees = current_user.blocked.map { |id| User.decode_id(id) }
    end

    @blockees
  end
end

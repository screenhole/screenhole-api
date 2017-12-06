class MemosController < ApplicationController
  before_action :authenticate_user, except: [:index]

  def index
    shot = Shot.find_by_hashid(params[:shot_id])

    unless shot.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Shot"
      } and return
    end

    render json: shot.memos
  end

  def show
    shot = Shot.find_by_hashid(params[:shot_id])

    unless shot.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Shot"
      } and return
    end

    memo = shot.memos.find_by_hashid(params[:id])

    unless memo.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Memo"
      } and return
    end

    render json: memo
  end

  def update
    memo = current_user.memos.find_by_hashid(params[:id])

    unless memo.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Memo"
      } and return
    end

    unless memo.shot.present? and memo.shot.hashid == params[:shot_id]
      render status: 400, json: {
        status: 400,
        detail: "shot_id doesn't match memo's"
      } and return
    end

    memo.update_attributes(item_params)

    if memo.save
      ActionCable.server.broadcast "memos_messages", ActiveModelSerializers::SerializableResource.new(memo).as_json
      render json: memo
    else
      respond_with_errors(memo)
    end
  end

  def create
    shot = Shot.find_by_hashid(params[:shot_id])

    unless shot.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Shot"
      } and return
    end

    memo = shot.memos.new

    memo.user = current_user

    memo.update_attributes(item_params)

    if memo.save
      ActionCable.server.broadcast "memos_messages", ActiveModelSerializers::SerializableResource.new(memo).as_json
      render json: memo
    else
      respond_with_errors(memo)
    end
  end

  def destroy
    memo = current_user.memos.find_by_hashid(params[:id])

    unless memo.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Memo"
      } and return
    end

    unless memo.shot.present? and memo.shot.hashid == params[:shot_id]
      render status: 400, json: {
        status: 400,
        detail: "shot_id doesn't match memo's"
      } and return
    end

    if memo.destroy
      # TODO: send delete over ActionCable
      render json: {
        status: 200,
        detail: "Success"
      }
    else
      render status: 400, json: {
        status: 400,
        detail: "Could not destroy memo"
      }
    end
  end

  def item_params
    params.require(:memo).permit(:variant, :media_path, :message)
  end
end

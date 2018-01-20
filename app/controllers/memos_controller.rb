class MemosController < ApplicationController
  before_action :authenticate_user, except: [:index]

  def index
    grab = Grab.find_by_hashid(params[:grab_id])

    unless grab.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Grab"
      } and return
    end

    render json: grab.memos.where(pending: false)
  end

  def show
    grab = Grab.find_by_hashid(params[:grab_id])

    unless grab.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Grab"
      } and return
    end

    memo = grab.memos.find_by_hashid(params[:id])

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

    unless memo.grab.present? and memo.grab.hashid == params[:grab_id]
      render status: 400, json: {
        status: 400,
        detail: "grab_id doesn't match memo's"
      } and return
    end

    memo.assign_attributes(item_params)

    if memo.save
      render json: memo
    else
      respond_with_errors(memo)
    end
  end

  def create
    grab = Grab.find_by_hashid(params[:grab_id])

    unless grab.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Grab"
      } and return
    end

    memo = grab.memos.new

    memo.user = current_user

    memo.assign_attributes(item_params)

    if memo.save
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

    unless memo.grab.present? and memo.grab.hashid == params[:grab_id]
      render status: 400, json: {
        status: 400,
        detail: "grab_id doesn't match memo's"
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
    meta_keys = params[:memo][:meta].try(:keys)

    params.require(:memo).permit(:variant, :pending, :media_path, :message, meta: meta_keys)
  end
end

class MemosController < ApplicationController
  before_action :authenticate_user, except: [:index]

  def index
    render json: Shot.find(params[:shot_id]).try(:memos)
  end

  def update
  end

  def create
    shot = Shot.find(params[:shot_id])
    memo = shot.memos.new

    memo.user = current_user

    memo.update_attributes(item_params)

    if memo.save
      render json: memo
    else
      respond_with_errors(memo)
    end
  end

  def destroy
  end

  def item_params
    params.require(:memo).permit(:variant, :media_path, :message)
  end
end

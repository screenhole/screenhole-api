class ChommentsController < ApplicationController
  before_action :authenticate_user, except: [:index]

  def index
    page = params[:page]
    per_page = params[:per_page] || 100

    chomments = Chomment.includes(:user, :cross_ref).order("created_at desc").page(page).per(per_page)

    render json: chomments, meta: pagination_dict(chomments)
  end

  def create
    chomment = current_user.chomments.new

    if chomment.update_attributes(item_params)
      chomment.notify_at_replied_users
      current_user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_chomment], "Generated chomment #{chomment.hashid}")
      render json: chomment
    else
      respond_with_errors(chomment)
    end
  end

  def item_params
    params.require(:chomment).permit(:message)
  end
end

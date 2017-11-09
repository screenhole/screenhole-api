class ChommentsController < ApplicationController
  before_action :authenticate_user, except: [:index]

  def index
    page = params[:page]
    per_page = params[:per_page] || 100

    chomments = Chomment.all.page(page).per(per_page)

    chomments.reverse_order!

    render json: chomments, meta: pagination_dict(chomments)
  end

  def create
    chomment = current_user.chomments.new

    chomment.update_attributes(item_params)

    if chomment.save
      ActionCable.server.broadcast "chomments_messages", ActiveModelSerializers::SerializableResource.new(chomment).as_json
      render json: chomment
    else
      respond_with_errors(chomment)
    end
  end

  def item_params
    params.require(:chomment).permit(:message)
  end
end

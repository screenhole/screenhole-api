class ChommentsController < ApplicationController
  CHOMMENTS_CACHE_KEY = 'chomments_json'.freeze

  before_action :authenticate_user, except: [:index]

  def index
    page = params[:page]
    per_page = 50

    chomments_json = Rails.cache.fetch(cache_key_for_page(page), expires_in: 5.minutes) do
      chomments = Chomment.includes(:user, :cross_ref).order("created_at desc").page(page).per(per_page)

      render_to_string(
        json: chomments,
        meta: pagination_dict(chomments)
      )
    end

    render json: chomments_json
  end

  def create
    chomment = current_user.chomments.new

    if chomment.update_attributes(item_params)
      chomment.notify_at_replied_users
      current_user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_chomment], "Generated chomment #{chomment.hashid}")
      Rails.cache.delete_matched("#{CHOMMENTS_CACHE_KEY}*")
      render json: chomment
    else
      respond_with_errors(chomment)
    end
  end

  def destroy
    chomment = current_user.chomments.find_by_hashid!(params[:id])

    chomment.destroy!

    Rails.cache.delete_matched("#{CHOMMENTS_CACHE_KEY}*")

    head :no_content
  end

  private

  def item_params
    params.require(:chomment).permit(:message)
  end

  def cache_key_for_page(page)
    "#{CHOMMENTS_CACHE_KEY}_page_#{page}"
  end
end

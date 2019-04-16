class Api::V2::ChatMessagesController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[index legacy_index]
  before_action :load_readable_hole, only: %i[index]
  before_action :load_writable_hole, only: %i[create destroy]

  PER_PAGE = 50

  def index
    @chat_messages = @hole.chat_messages.page(params[:page]).per(PER_PAGE)

    render(
      json: @chat_messages,
      meta: pagination_dict(@chat_messages)
    )
  end

  def legacy_index
    @chomments = Chomment.includes(:user, :cross_ref).order("created_at desc").page(params[:page]).per(PER_PAGE)

    render(
      json: @chomments,
      meta: pagination_dict(@chomments),
      root: 'chat_messages'
    )
  end

  def create
    @chat_message = @hole.chat_messages.new(chat_message_params).tap do |m|
      m.user = current_user
    end

    if @chat_message.save
      # TODO: Notify @replied users, buttcoin credit, ActionCable
      render json: @chat_message, status: :created
    else
      respond_with_errors(@chat_message)
    end
  end

  def destroy
    @chat_message = @hole.chat_messages.find_by!(id: params[:id], user: current_user)

    if @chat_message.destroy
      # TODO: ActionCable
      head :no_content
    else
      respond_with_errors(@chat_message)
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:message)
  end

  def load_readable_hole
    @hole = Hole.find_by!(subdomain: params[:hole_id])
  end

  def load_writable_hole
    @hole = current_user.holes.find_by!(subdomain: params[:hole_id])
  end
end

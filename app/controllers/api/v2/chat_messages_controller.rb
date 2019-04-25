class Api::V2::ChatMessagesController < Api::V2::ApplicationController
  before_action :authenticate_user, except: %i[index legacy_index]
  before_action :load_readable_hole, only: %i[index]
  before_action :load_writable_hole, only: %i[create destroy]

  PER_PAGE = 50

  def index
    @chat_messages = if @hole
                       @hole.chat_messages.page(params[:page]).per(PER_PAGE)
                     else
                       Chomment
                         .includes(:user, :cross_ref)
                         .order('created_at desc')
                         .page(params[:page])
                         .per(PER_PAGE)
                     end

    render(
      json: @chat_messages,
      meta: pagination_dict(@chat_messages),
      root: 'chat_messages'
    )
  end

  def create
    @chat_message = if @hole
                      @hole.chat_messages.new(chat_message_params).tap do |m|
                        m.user = current_user
                      end
                    else
                      current_user.chomments.new(chat_message_params)
                    end

    if @chat_message.save
      if @chat_message.is_a?(Chomment)
        @chat_message.notify_at_replied_users
        current_user.buttcoin_transaction(
          Buttcoin::AMOUNTS[:create_chomment],
          "Generated chat message #{@chat_message.hashid}"
        )
      end

      # TODO: Notify @replied users, buttcoin credit
      render json: @chat_message, status: :created, root: 'chat_message'
    else
      respond_with_errors(@chat_message)
    end
  end

  def destroy
    @chat_message = @hole.chat_messages.find_by!(id: params[:id], user: current_user)

    if @chat_message.destroy
      head :no_content
    else
      respond_with_errors(@chat_message)
    end
  end

  def legacy_index
    @chomments = Chomment.includes(:user, :cross_ref).order('created_at desc').page(params[:page]).per(PER_PAGE)

    render(
      json: @chomments,
      meta: pagination_dict(@chomments),
      root: 'chat_messages'
    )
  end

  def legacy_create
    chomment = current_user.chomments.new(chat_message_params)

    if chomment.save
      chomment.notify_at_replied_users
      current_user.buttcoin_transaction(
        Buttcoin::AMOUNTS[:create_chomment],
        "Generated chomment #{chomment.hashid}"
      )

      render json: chomment, root: 'chat_message'
    else
      respond_with_errors(chomment)
   end
 end

  private

  def chat_message_params
    params.require(:chat_message).permit(:message)
  end
end

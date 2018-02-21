class ButtcoinsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "buttcoins_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "buttcoins_messages", data
  end

  def unsubscribed
  end
end

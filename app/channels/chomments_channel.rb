class ChommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chomments_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "chomments_messages", data
  end

  def unsubscribed
  end
end

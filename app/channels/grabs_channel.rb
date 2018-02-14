class GrabsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "grabs_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "grabs_messages", data
  end

  def unsubscribed
  end
end

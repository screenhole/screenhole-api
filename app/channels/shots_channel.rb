class ShotsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "shots_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "shots_messages", data
  end

  def unsubscribed
  end
end

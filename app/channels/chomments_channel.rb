class ChommentsChannel < ApplicationCable::Channel
  def subscribed
    current_user.try(:presence).try(:appear!)
    stream_from "chomments_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "chomments_messages", data
  end

  def unsubscribed
    current_user.try(:presence).try(:disappear!)
  end
end

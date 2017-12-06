class MemosChannel < ApplicationCable::Channel
  def subscribed
    stream_from "memos_messages"
  end

  def receive(data)
    ActionCable.server.broadcast "memos_messages", data
  end

  def unsubscribed
  end
end

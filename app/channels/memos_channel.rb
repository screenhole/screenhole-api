class MemosChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      channel_name('memos')
    )
  end

  def receive(data)
    ActionCable.server.broadcast(
      channel_name('memos'),
      data
    )
  end

  def unsubscribed
  end
end

class GrabsChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      channel_name('grabs')
    )
  end

  def receive(data)
    ActionCable.server.broadcast(
      channel_name('grabs'),
      data
    )
  end

  def unsubscribed
  end
end

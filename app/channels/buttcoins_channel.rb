class ButtcoinsChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      channel_name('buttcoins')
    )
  end

  def receive(data)
    ActionCable.server.broadcast(
      channel_name('buttcoins'),
      data
    )
  end

  def unsubscribed
  end
end

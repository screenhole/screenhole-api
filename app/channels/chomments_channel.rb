class ChommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      channel_name('chomments')
    )
  end

  def receive(data)
    ActionCable.server.broadcast(
      channel_name('chomments'),
      data
    )
  end

  def unsubscribed
  end
end

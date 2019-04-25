class NotesChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      channel_name('notes')
    )
  end

  def receive(data)
    ActionCable.server.broadcast(
      channel_name('notes'),
      data
    )
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class NotesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notes_channel'
  end

  def receive(data)
    ActionCable.server.broadcast 'notes_channel', data
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

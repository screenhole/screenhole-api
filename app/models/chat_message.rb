class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :hole

  after_create :broadcast_via_cable

  validates(
    :user,
    presence: true
  )

  validates(
    :hole,
    presence: true
  )

  validates(
    :message,
    presence: true,
    length: { minimum: 3, maximum: 255 }
  )

  private

  def broadcast_via_cable
    ActionCable.server.broadcast(
      hole.cable_channel_name('chomments'),
      ActiveModelSerializers::SerializableResource.new(self).as_json
    )
  end
end

class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :hole

  after_create :broadcast_via_cable
  after_create :credit_buttcoin

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

  default_scope -> { order('created_at DESC') }

  private

  def broadcast_via_cable
    ActionCable.server.broadcast(
      hole.cable_channel_name('chomments'),
      ActiveModelSerializers::SerializableResource.new(self).as_json
    )
  end

  def credit_buttcoin
    user.buttcoin_transaction(
      Buttcoin::AMOUNTS[:create_chomment],
      "Generated chat message #{id}"
    )
  end
end

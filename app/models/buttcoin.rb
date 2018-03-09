class Buttcoin < ApplicationRecord
  include Hashid::Rails

  belongs_to :user

  after_save :channel_broadcast

  AMOUNTS = {
    create_grab: 500,
    create_chomment: 10,

    create_voice_memo: 2_000,
    receive_voice_memo: 2_000,

    create_chomment_memo_per_char: -1,
    receive_chomment_memo_per_char: 1,

    generate_invite: -10_000,
  }

  def channel_broadcast
    ActionCable.server.broadcast "buttcoins_messages", ActiveModelSerializers::SerializableResource.new(self).as_json
  end

  def self.market_cap
    Buttcoin.sum(:amount)
  end
end

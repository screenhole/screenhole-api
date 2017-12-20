class Buttcoin < ApplicationRecord
  belongs_to :user

  AMOUNTS = {
    create_shot: 11,
    create_voice_memo: 9,
    receive_voice_memo: 13,
  }
end

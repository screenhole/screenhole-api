class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :hole

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
end

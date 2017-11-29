class Memo < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :shot

  enum variant: [
    :generic,
    :voice,
  ]
end

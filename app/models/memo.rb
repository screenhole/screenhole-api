class Memo < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :shot

  enum variant: [
    :generic,
    :voice,
  ]

  before_create :generate_calling_code

  def generate_calling_code
    # actual code is 5 digits. trailing digits denote env.
    # e.g. 11111 is prod, 111119 is staging.
    self.calling_code = SecureRandom.random_number(10000..99999)
    generate_calling_code if Memo.exists?(calling_code: self.calling_code)
  end
end

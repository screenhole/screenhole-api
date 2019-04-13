class Invite < ApplicationRecord
  include Hashid::Rails

  belongs_to :user

  before_create :generate_code

  validate do
    if (user.buttcoin_balance + Buttcoin::AMOUNTS[:generate_invite]).negative?
      errors.add(:base, 'insufficient funds')
    end
  end

  def redeemed
    !! invited_id
  end

  protected

  def generate_code
    self.code = loop do
      random_code = rand(36**8).to_s(36).downcase
      break random_code unless Invite.exists?(code: random_code)
    end
  end
end

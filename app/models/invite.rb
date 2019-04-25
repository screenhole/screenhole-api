class Invite < ApplicationRecord
  include Hashid::Rails

  belongs_to :hole, optional: true
  belongs_to :user

  before_create :generate_code
  after_create :debit_buttcoin

  validate :must_have_funds, on: :create

  def redeemed
    !!invited_id
  end

  protected

  def generate_code
    self.code = loop do
      random_code = rand(36**8).to_s(36).downcase
      break random_code unless Invite.exists?(code: random_code)
    end
  end

  def debit_buttcoin
    user.buttcoin_transaction(
      Buttcoin::AMOUNTS[:generate_invite],
      "Generated invite #{hashid}"
    )
  end

  def must_have_funds
    return if (
      user.buttcoin_balance + Buttcoin::AMOUNTS[:generate_invite]
    ).positive?

    errors.add(:base, 'insufficient funds')
  end
end

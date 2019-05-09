class GrabTip < ApplicationRecord
  belongs_to :grab
  belongs_to :user

  validate :must_have_funds, on: :create

  after_create :reconcile_buttcoin

  def amount
    69
  end

  private

  def reconcile_buttcoin
    user.buttcoin_transaction(
      amount,
      "m'lady"
    )
  end

  def must_have_funds
    errors.add(:base, 'insufficient funds') if user.blank? || (user.buttcoin_balance + amount) <= 0
  end
end

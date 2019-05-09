class GrabTip < ApplicationRecord
  belongs_to :grab
  belongs_to :user

  validate :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :must_have_funds, on: :create

  after_create :debit_buttcoin_from_tipper
  after_create :credit_buttcoin_to_grab_author

  private

  def credit_buttcoin_to_grab_author
    grab.user.buttcoin_transaction(
      amount,
      to_global_id
    )
  end

  def debit_buttcoin_from_tipper
    user.buttcoin_transaction(
      -amount,
      to_global_id
    )
  end

  def must_have_funds
    errors.add(:base, 'insufficient funds') if user.blank? || (user.buttcoin_balance + amount) <= 0
  end
end

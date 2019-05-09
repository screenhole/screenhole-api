class GrabComment < ApplicationRecord
  belongs_to :user
  belongs_to :grab

  validates :message, presence: true
  validate :must_have_funds, on: :create

  after_create :debit_buttcoin_from_author

  private

  def cost
    -(message.to_s.length)
  end

  def debit_buttcoin_from_author
    user.buttcoin_transaction(
      cost,
      to_global_id
    )
  end

  def must_have_funds
    errors.add(:base, 'insufficient funds') if user.blank? || (user.buttcoin_balance + cost) <= 0
  end
end

class ButtcoinSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :amount

  attribute :balance

  belongs_to :user

  def balance
    object.user.buttcoin_balance
  end

  def is_current_user?
    defined? current_user && object.user_id == current_user.id
  end
end

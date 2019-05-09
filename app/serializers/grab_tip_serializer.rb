class GrabTipSerializer < ActiveModel::Serializer
  attributes :created_at, :amount

  belongs_to :user
  belongs_to :grab
end

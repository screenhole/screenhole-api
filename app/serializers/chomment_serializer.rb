class ChommentSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :message

  belongs_to :user

  def is_current_user?
    defined? current_user && object.id == current_user.id
  end
end
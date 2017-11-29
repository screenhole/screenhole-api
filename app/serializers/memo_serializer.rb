class MemoSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :variant, :message, :media_path

  belongs_to :user
  belongs_to :shot

  def is_current_user?
    defined? current_user && object.user_id == current_user.id
  end
end

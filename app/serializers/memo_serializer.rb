class MemoSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at,
    :variant,
    :message,
    :media_path,
    :pending

  attribute :calling_code, if: :is_current_user?

  belongs_to :user
  belongs_to :shot

  def is_current_user?
    begin
      object.user_id == current_user.id
    rescue
      false
    end
  end
end

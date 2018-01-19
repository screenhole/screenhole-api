class MemoSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at,
    :variant,
    :pending,
    :message,
    :media_public_url,
    :meta

  attribute :calling_code, if: :is_current_user?

  belongs_to :user
  belongs_to :grab

  def is_current_user?
    begin
      object.user_id == current_user.id
    rescue
      false
    end
  end
end

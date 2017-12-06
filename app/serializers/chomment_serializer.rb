class ChommentSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :message

  belongs_to :user

  def is_current_user?
    begin
      object.user_id == current_user.id
    rescue
      false
    end
  end
end
class InviteSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :code

  has_one :invited

  def invited
    User.find(object.invited_id) if object.invited_id
  end

  def is_current_user?
    begin
      object.user_id == current_user.id
    rescue
      false
    end
  end
end

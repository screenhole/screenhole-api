class InviteSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :code

  has_one :invited

  def invited
    return nil unless object.invited_id.present?

    User.find_by(id: object.invited_id)
  end
end

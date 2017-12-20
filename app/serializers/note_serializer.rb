class NoteSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :variant, :meta, :cross_ref_type

  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :cross_ref

  def is_current_user?
    begin
      object.user_id == current_user.id
    rescue
      false
    end
  end
end

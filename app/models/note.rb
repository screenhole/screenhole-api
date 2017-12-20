class Note < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :cross_ref, polymorphic: true

  serialize :meta, Hash

  validates_presence_of :key, :user
end

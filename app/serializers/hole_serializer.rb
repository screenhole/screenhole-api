# frozen_string_literal: true

class HoleSerializer < ActiveModel::Serializer
  attributes :name, :subdomain, :rules
end

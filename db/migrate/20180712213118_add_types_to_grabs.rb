# frozen_string_literal: true

# :nodoc:
class AddTypesToGrabs < ActiveRecord::Migration[5.1]
  def change
    add_column :grabs, :gtype, :integer, default: 0
  end
end

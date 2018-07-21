# frozen_string_literal: true

# :nodoc:
class RenameColumnGtypeMediaTypeGrabs < ActiveRecord::Migration[5.1]
  def up
    rename_column :grabs, :gtype, :media_type
  end

  def down
    rename_column :grabs, :media_type, :gtype
  end
end

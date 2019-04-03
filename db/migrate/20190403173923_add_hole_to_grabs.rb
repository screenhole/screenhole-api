class AddHoleToGrabs < ActiveRecord::Migration[5.2]
  def change
    add_reference :grabs, :hole, foreign_key: true
  end
end

class CreateGrabTips < ActiveRecord::Migration[5.2]
  def change
    create_table :grab_tips do |t|
      t.belongs_to :grab, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end

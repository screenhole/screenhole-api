class CreateShots < ActiveRecord::Migration[5.1]
  def change
    create_table :shots do |t|
      t.string :image_path

      t.timestamps
    end

    add_reference :shots, :user, index: true
  end
end

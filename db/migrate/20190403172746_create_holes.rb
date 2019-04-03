class CreateHoles < ActiveRecord::Migration[5.2]
  def change
    create_table :holes do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
  end
end

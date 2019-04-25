class AddAcceleratorMetadataToGrabs < ActiveRecord::Migration[5.2]
  def change
    add_column :grabs, :accelerator_metadata, :jsonb
  end
end

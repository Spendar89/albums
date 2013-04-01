class AddMbIdToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :mb_id, :string
  end
end

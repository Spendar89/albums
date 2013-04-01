class AddInCollectionToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :in_collection, :boolean
  end
end

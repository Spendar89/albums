class AddAlbumArtToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_art, :string
  end
end

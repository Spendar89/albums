class AddDiscogsIdToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :discogs_id, :string
  end
end

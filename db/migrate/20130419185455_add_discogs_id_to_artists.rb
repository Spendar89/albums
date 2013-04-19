class AddDiscogsIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :discogs_id, :string
  end
end

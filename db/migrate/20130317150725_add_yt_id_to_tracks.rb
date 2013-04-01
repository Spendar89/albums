class AddYtIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :yt_id, :string
  end
end

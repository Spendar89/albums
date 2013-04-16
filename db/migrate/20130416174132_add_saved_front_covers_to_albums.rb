class AddSavedFrontCoversToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :saved_front_covers, :text
  end
end

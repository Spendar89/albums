class AddSavedBackCoversToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :saved_back_covers, :text
  end
end

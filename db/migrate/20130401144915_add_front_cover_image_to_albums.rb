class AddFrontCoverImageToAlbums < ActiveRecord::Migration
  def up
    add_attachment :albums, :front_cover_image
  end
  
  def down
    remove_attachment :albums, :front_cover_image
  end
end

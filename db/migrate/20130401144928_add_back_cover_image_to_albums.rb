class AddBackCoverImageToAlbums < ActiveRecord::Migration
  def up
    add_attachment :albums, :back_cover_image
  end
  
  def down
    remove_attachment :albums, :back_cover_image
  end

end

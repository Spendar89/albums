class AddBackCoverAndFrontCoverToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :back_cover, :string
    add_column :albums, :front_cover, :string
  end
end

class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.string :genre
      t.datetime :release_date

      t.timestamps
    end
  end
end

class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :position
      t.integer :album_id

      t.timestamps
    end
  end
end

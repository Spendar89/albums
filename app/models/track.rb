class Track < ActiveRecord::Base
  attr_accessible :album_id, :position, :title, :yt_id
  belongs_to :album
end

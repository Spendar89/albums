class Track < ActiveRecord::Base
  attr_accessible :album_id, :position, :title, :yt_id
  belongs_to :album
  before_create :set_yt_id
  is_impressionable
  
  def set_yt_id(title_terms = nil, attempt = 1)
      title_terms ||= title
      search_result = Youtube::Search.new("#{album.artist_name}  #{title_terms}").try(:yt_id)
      return self.yt_id = search_result if search_result 
      set_yt_id(title_terms.split("(")[0], 2) unless attempt == 2
  end
  
  def self.listened_to_today
    Impression.where("created_at >= ?", Time.zone.now.beginning_of_day).map do |i|
      track = i.impressionable
      album = track.try(:album)
      artist = album.try(:artist)
      {track: track.try(:title), album: album.try(:title), artist: artist.try(:name), ip: i.ip_address}
    end
  end
end

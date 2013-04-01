require 'net/http'
require 'open-uri'
class Artist < ActiveRecord::Base
  attr_accessible :mb_id, :name
  after_create do
    set_mb_id
  end
    
  has_many :albums
  
  def set_albums(album_title)
    album_hash_array = JSON.parse(open("http://musicbrainz.org/ws/2/artist/#{mb_id}?inc=releases&fmt=json").read)["releases"]
    matching_album = album_hash_array.select{|album_hash| album_hash["title"] == album_title }.first
    album = self.albums.create(:title => matching_album["title"], :artist_name => name, :mb_id => matching_album["id"], :in_collection => true)
    album
  end
  
  private
    def set_mb_id
      mb_id = JSON.parse(open("http://musicbrainz.org/ws/2/artist/?query=#{URI.escape(self.name)}&fmt=json").read)["artist"][0]["id"]
      self.update_attribute(:mb_id, mb_id)
    end
  
end

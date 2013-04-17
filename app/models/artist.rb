require 'net/http'
require 'open-uri'
require 'discogs'
class Artist < ActiveRecord::Base
  attr_accessible :mb_id, :name
    
  has_many :albums
  validate :artist_must_be_in_discogs

  
  def discogs_name
    JSON.parse(open("http://api.discogs.com/database/search?type=artist&q=#{CGI::escape(name)}").read)["results"][0]["title"]
  end
  
  def albums!
    Discogs::Wrapper.new("albums").get_artist(discogs_name).main_releases
  end
  
  def artist_must_be_in_discogs
    results = JSON.parse(open("http://api.discogs.com/database/search?type=artist&q=#{CGI::escape(discogs_name)}").read)["results"]
    errors.add(:name, "Cannot Find Artist") if results.empty?
  end
  
  def set_album(album_title)
    matching_album = albums!.select{|release| release.title.downcase == album_title.downcase}.first
    raise CannotFindAlbum, "No Matching Albums" unless matching_album
    album = self.albums.find_or_create_by_title(matching_album.title, :artist_name => name, :in_collection => true)
    album
  end
  
end


class CannotFindAlbum < Exception 
end

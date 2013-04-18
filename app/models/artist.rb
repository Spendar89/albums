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
  
  def pretty_albums
    albums!.map{|a| {:title => a.title, :release_id => a.main_release} if a.main_release}.try(:compact)
  end
  
  def artist_must_be_in_discogs
    results = JSON.parse(open("http://api.discogs.com/database/search?type=artist&q=#{CGI::escape(discogs_name)}").read)["results"]
    errors.add(:name, "Cannot Find Artist") if results.empty?
  end
  
  def set_album(album_title, discogs_id)
    album = self.albums.find_or_create_by_title(album_title, :artist_name => name, :in_collection => true, :discogs_id => discogs_id)
    album.update_attribute(:discogs_id, discogs_id) unless album.discogs_id
    album
  end
  
end


class CannotFindAlbum < Exception 
end

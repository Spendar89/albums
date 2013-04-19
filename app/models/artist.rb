require 'net/http'
require 'open-uri'
require 'discogs'
class Artist < ActiveRecord::Base
  attr_accessible :mb_id, :name, :discogs_id
    
  has_many :albums
  
  def self.search(query)
     JSON.parse(open("http://api.discogs.com/database/search?type=artist&q=#{CGI::escape(query)}").read)["results"].map{|a| {'id' => a['id'], 'name' => a['title']}}
  end
  
  def albums!
    JSON.parse(open("http://api.discogs.com/artists/#{discogs_id}/releases").read)["releases"]
    # Discogs::Wrapper.new("albums").get_artist(name).main_releases
  end
  
  def pretty_albums
    albums!.map{|a| {:title => a["title"], :release_id => a["main_release"]} if a["main_release"]}.try(:compact)
  end
  
  def artist_must_be_in_discogs
    results = JSON.parse(open("http://api.discogs.com/database/search?type=artist&q=#{CGI::escape(discogs_name)}").read)["results"]
    errors.add(:name, "Cannot Find Artist") if results.empty?
  end
  
  def set_album(album_title, discogs_id)
    album = self.albums.find_or_create_by_title(album_title, :artist_name => name, :in_collection => true, :discogs_id => discogs_id)
    album.update_attributes(:discogs_id => discogs_id) if album.discogs_id != discogs_id
    album
  end
  
end


class CannotFindAlbum < Exception 
end

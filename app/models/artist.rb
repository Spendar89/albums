require 'net/http'
require 'open-uri'
require 'discogs'
class Artist < ActiveRecord::Base
  attr_accessible :mb_id, :name
    
  has_many :albums
  validate :artist_must_be_in_discogs
  
  # def cover_art
  #   wrapper = Discogs::Wrapper.new("albums")
  #   artist_name = self.artist_name
  #   artist_name = "#{artist_name[4..-1]}, the" if artist_name.split(" ").first.downcase == "the"
  #   all_releases = wrapper.get_artist(artist_name).main_releases
  #   release = all_releases.select{|release| release.title == self.title}.first
  #   return unless release
  #   release_id = release.main_release
  #   wrapper.get_release(release_id).images if release_id
  # end
  
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
    matching_album = albums!.select{|release| release.title == album_title}.first
    raise CannotFindAlbum, "No Matching Albums" unless matching_album
    album = self.albums.find_or_create_by_title(matching_album.title, :artist_name => name, :in_collection => true)
    album
  end
  
  private
    def set_mb_id
      mb_id = JSON.parse(open("http://musicbrainz.org/ws/2/artist/?query=#{URI.escape(self.name)}&fmt=json").read)["artist"][0]["id"]
      self.update_attribute(:mb_id, mb_id)
    end
  
end


class CannotFindAlbum < Exception 
end

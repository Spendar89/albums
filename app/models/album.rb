require 'net/http'
require 'open-uri'
require 'discogs'
require 'wikipedia'
require 'nokogiri'


class Album < ActiveRecord::Base
  
  attr_accessible :genre, :release_date, :title, :album_art, :artist_name, :mb_id, :in_collection, :front_cover_image, :back_cover_image, :description
  has_many :tracks
  belongs_to :artist
  validates :title, :uniqueness => {:scope => :artist_id}
  after_create do 
    set_tracks
    set_cover_art
  end
  
  has_attached_file :front_cover_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  
  has_attached_file :back_cover_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  
  def set_yt_ids
    self.tracks.each do |track|
      search_result = Youtube::Search.new("#{self.artist_name}  #{track.title}").try(:yt_id) 
      track.update_attribute(:yt_id, search_result) if search_result
    end 
  end
  
  def get_result
    q = CGI::escape("#{title.gsub(' ','_')}")
    first = JSON.parse(open("http://en.wikipedia.org/w/api.php?format=json&action=parse&page=#{q}&prop=text&section=0").read)
    second =  JSON.parse(open("http://en.wikipedia.org/w/api.php?format=json&action=parse&page=#{q}_(album)&prop=text&section=0").read)
    return first["parse"]["text"]["*"] if has_description?(first)
    return second["parse"]["text"]["*"] if has_description?(second)
  end
  
  def set_description
    result = get_result
    Nokogiri::HTML(result).css("p").text.split(".")[0...-1].join(".") + "." if result
  end
  
  def has_description?(result)
    unless result["error"]
      true unless result["parse"]["text"]["*"].include?("NOTBROKEN") 
    end
  end
  
  def cover_art
    wrapper = Discogs::Wrapper.new("albums")
    artist_name = self.artist_name
    artist_name = "#{artist_name[4..-1]}, the" if artist_name.split(" ").first.downcase == "the"
    all_releases = wrapper.get_artist(artist_name).main_releases
    release = all_releases.select{|release| release.title == self.title}.first
    return unless release
    release_id = release.main_release
    wrapper.get_release(release_id).images if release_id
  end
    
  def get_front_cover
    begin
      cover_art.select{|image| image.type == "primary"}.first.uri
      rescue NoMethodError
        nil
    end
  end
  
  def all_back_covers
    begin
    cover_art.select{|image| image.type == "secondary"}.map{|cover| cover.uri}.compact
    rescue NoMethodError
      nil
    end
  end
  
  def all_front_covers
    begin
      cover_art.select{|image| image.type == "primary"}.map{|cover| cover.uri}.compact
    rescue NoMethodError
      nil
    end
  end
  
  def get_back_cover
    begin
      cover_art.select{|image| image.type == "secondary"}.last.uri
      rescue NoMethodError
        nil
    end
  end
  
  def converted_front_cover(url=nil)
    file_name = "album_art/front_#{self.title.downcase.gsub(' ', '_').gsub('/', '_')}.jpg"
    album_art_file = "app/assets/images/#{file_name}"
    open(album_art_file, 'wb') do |file|
      url ? file << open(url).read : file << open(get_front_cover).read
    end
    file_name
  end
  
  def converted_back_cover(url=nil)
    unless get_back_cover.nil? && url.nil?
      file_name = "album_art/back_#{self.title.downcase.gsub(' ', '_').gsub('/', '_')}.jpg"
      album_art_file = "app/assets/images/#{file_name}"
      open(album_art_file, 'wb') do |file|
        url ? file << open(url).read : file << open(get_back_cover).read
      end
      file_name
    end
  end
  
  def set_cover_art
    self.update_attributes(:front_cover => get_front_cover, :back_cover => get_back_cover)
  end
  
  def set_back_cover(url)
    self.update_attributes(:back_cover => url)
  end
  
  def set_front_cover(url)
    self.update_attributes(:front_cover => url)
  end
      
  private
    def track_data
      tracks_hash_array = JSON.parse(open("http://musicbrainz.org/ws/2/release/#{self.mb_id}?inc=recordings&fmt=json").read)["media"][0]["tracks"]
      tracks = tracks_hash_array.map do |track_hash|
        track_hash["title"]
      end
      tracks.compact
    end
  
    def set_tracks
      self.tracks.each{|track| track.destroy }
      track_data.each_with_index{|track, i| self.tracks.create(title: track, position: i+1)}
    end
  
end

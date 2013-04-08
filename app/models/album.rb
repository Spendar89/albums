require 'net/http'
require 'open-uri'
require 'discogs'
require 'wikipedia'
require 'nokogiri'
require 'digest/md5'


class Album < ActiveRecord::Base
  
  attr_accessible :genre, :release_date, :title, :album_art, :artist_name, :mb_id, :in_collection, :front_cover_image, :back_cover_image, :description
  has_many :tracks
  belongs_to :artist
  validates :title, :uniqueness => {:scope => :artist_id}
  after_create do 
    set_tracks
    set_description
  end
  
  has_attached_file :front_cover_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '500x500>'
  }
  
  has_attached_file :back_cover_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '500x500>'
  }
  
  def discogs_id
    hash = JSON.parse(open("http://api.discogs.com/database/search?type=releases&artist=#{CGI::escape(artist.discogs_name)}&release_title=#{CGI::escape(title)}").read)
    hash["results"].first["id"]
  end
  
  def artist
    Artist.find_by_name(artist_name)
  end
  
  def tracklist
    JSON.parse(open("http://api.discogs.com/releases/#{discogs_id}").read)["tracklist"]
  end
  
  def get_result
    q = CGI::escape("#{title.gsub(' ','_')}")
    first = JSON.parse(open("http://en.wikipedia.org/w/api.php?format=json&action=parse&page=#{q}&prop=text&section=0").read)
    second =  JSON.parse(open("http://en.wikipedia.org/w/api.php?format=json&action=parse&page=#{q}_(album)&prop=text&section=0").read)
    return first["parse"]["text"]["*"] if has_description?(first)
    return second["parse"]["text"]["*"] if has_description?(second)
  end
  
  def get_description
    result = get_result
    Nokogiri::HTML(result).css("p").text.split(".")[0...-1].join(".") + "." if result
  end
  
  def set_description
    self.update_attributes(:description => get_review)
  end
  
  def rovi_md5
    api_key = ENV['ROVI_API_KEY']
    secret_key = ENV['ROVI_SECRET_KEY']
    unix_time = Time.now.to_i.to_s
    text = api_key + secret_key + unix_time
    Digest::MD5.hexdigest(text)
  end
  
  def get_review
    rovi_api_key = ENV['ROVI_API_KEY']
    hash = JSON.parse(open("http://api.rovicorp.com/data/v1/album/primaryreview?album=#{title.gsub(' ', '+')}&country=US&language=en&format=json&apikey=#{rovi_api_key}&sig=#{rovi_md5}").read)
    hash["primaryReview"]["text"].gsub(/\[\/{0,1}roviLink.{0,20}\]/, "")
  end
  
  def has_description?(result)
    unless result["error"]
      true unless result["parse"]["text"]["*"].include?("NOTBROKEN") 
    end
  end
  
  def cover_art
    wrapper = Discogs::Wrapper.new("albums")
    wrapper.get_release(discogs_id).try(:images)
  end
  
  def set_covers_from_urls(front_url, back_url)
    self.update_attributes(:front_cover_image => open(front_url)) unless front_url.empty?
    self.update_attributes(:back_cover_image => open(back_url)) unless back_url.empty?
  end
  
  def set_default_covers
    set_default_front_cover
    set_default_back_cover
  end
  
  def set_default_front_cover(index = 0)
    front_cover_url = get_front_cover(index)
    self.update_attributes(:front_cover_image => open(front_cover_url)) if front_cover_url
  end
  
  def set_default_back_cover(index = 0)
    back_cover_url = get_back_cover(index)
    self.update_attributes(:back_cover_image => open(back_cover_url)) if back_cover_url
  end
  
    
  def get_front_cover(index = 0)
    all_front_covers[index]
  end
  
  def get_back_cover(index = 0)
    all_back_covers[index]
  end
  
  def all_back_covers
    cover_art.select{|image| image.try(:type) == "secondary"}.map{|cover| cover.try(:uri)}.compact
  end
  
  def all_front_covers
    cover_art.select{|image| image.try(:type) == "primary"}.map{|cover| cover.try(:uri)}.compact
  end
  
  def set_tracks!
    self.tracks.each{|track| track.destroy }
    tracklist.each{|track| self.tracks.create(title: track["title"], position: track["position"])}
  end
      
  private

  def set_tracks
    tracklist.each{|track| self.tracks.create(title: track["title"], position: track["position"])}
  end
  
end

class CannotFindCover < Exception 
end

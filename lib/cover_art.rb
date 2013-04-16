require 'net/http'
require 'open-uri'
require 'discogs'

class CoverArt
  def initialize(discogs_id)
    @discogs_id = discogs_id
    @master_id ||= get_master_id
    @all_version_urls ||= get_all_version_urls
    @wrapper = Discogs::Wrapper.new("albums")
    @all = get_all
  end
  
  def get_master_id
    JSON.parse(open("http://api.discogs.com/releases/#{ @discogs_id}").read)["master_id"]
  end
  
  def get_all_version_urls
    JSON.parse(open("http://api.discogs.com/masters/#{@master_id}/versions").read)["versions"].map{|v| v["resource_url"]}.compact
  rescue
    return nil
  end
  
  def image_array(version_url)
    JSON.parse(open("#{version_url}").read)["images"]
  end
    
  def get_all
    return unless @all_version_urls
    @all_version_urls.map { |version_url|
      images = image_array(version_url).try(:map){ |image|
        image
      }
    }.flatten.compact
  end
  
  def back_uris
    @all.try(:map){|image| (image["uri"] if image["type"] != "primary") if image}.compact
  end
  
  def front_uris
    @all.try(:map){|image| (image["uri"] if image["type"] == "primary") if image}.compact
  end
  
end
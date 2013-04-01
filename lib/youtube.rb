require 'youtube_it'

module Youtube
  class Search
    def initialize(query)
      @client = YouTubeIt::Client.new(:dev_key => "AI39si7F87ZBi_Vp0PPnGiDdjGoKrEPmsVCzbQ7NQn1-1Zm9gCiKwhZIXEmaVK6ficykFRSKKBh4ekkzIwr19Ahrq72MWurw_w")
      @query = query
    end
    
    def results
      @client.videos_by(:query => @query)
    end
  
    def yt_id
      results.videos.first.video_id.split(":").last
    end
  end
end
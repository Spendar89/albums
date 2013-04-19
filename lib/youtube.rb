require 'youtube_it'

module Youtube
  class Search
    def initialize(query)
      @client = YouTubeIt::Client.new(:dev_key => "AI39si7F87ZBi_Vp0PPnGiDdjGoKrEPmsVCzbQ7NQn1-1Zm9gCiKwhZIXEmaVK6ficykFRSKKBh4ekkzIwr19Ahrq72MWurw_w")
      @query = query
    end
    
    def results
      @client.videos_by(:query => @query, :categories => [:music])
    end
  
    def yt_id
      start = Time.now.to_f
      video_id = results.videos.first.try(:video_id)
      video_id = video_id.split(":").last if video_id
      finish = Time.now.to_f
      puts "found yt_id in #{finish - start} seconds"
      return video_id
    end
  end
end
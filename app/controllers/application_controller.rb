class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def search_results(track_title, artist_name)
    $youtube.videos_by(:query => "#{track_title} #{artist_name}")
  end
  
end

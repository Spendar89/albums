class TracksController < ApplicationController
  def count_play
    @track = Track.find_by_yt_id(params["id"])
    impressionist(@track)
    render :nothing => true
  end
end

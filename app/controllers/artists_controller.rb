class ArtistsController < ApplicationController
  def create
    begin
    @artist = Artist.find_or_create_by_name(:name => params[:artist_name][0])
    @albums_list = @artist.pretty_albums
    rescue
      @errors = "Cannot Find Artist"
    end
  end
end

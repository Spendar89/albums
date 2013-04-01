class AlbumsController < ApplicationController
  include Youtube
  
  def new
    @album = Album.new
  end
  
  def preview
    begin
      @artist = Artist.find_or_create_by_name(:name => params[:artist_name][0])
      @album = @artist.set_albums(params[:title][0])
      @album.set_yt_ids
      @album.title
      @album.set_default_covers
    rescue NoMethodError
      flash[:notice] = "Cannot Find Album"
      redirect_to new_album_path and return
    end
  end
  
  def create
    begin
      @artist = Artist.find(params[:artist_id])
      @album = Album.find(params[:album_id])
      @album.set_covers_from_urls(params[:front_cover_url], params[:back_cover_url])
    rescue NoMethodError
      flash[:notice] = "Cannot Find Album"
      redirect_to new_album_path and return
    end
    redirect_to albums_path
  end
  
  def show
  end
  
  def update
  end
  
  def destroy
  end
  
  def index
    @albums = Album.where("albums.in_collection = ?", true)
  end
end

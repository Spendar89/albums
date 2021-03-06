class AlbumsController < ApplicationController
  include Youtube
  
  def new
    @album = Album.new
  end
  
  def preview
    @artist = Artist.find_or_create_by_name(:name => params[:artist_name])
    @album = @artist.set_album(params[:title], params[:discogs_id])
    @album.set_default_covers unless @album.saved_front_covers && @album.saved_back_covers
  end
  
  def change_cover
    begin
    @album = Album.find(params[:id])
    @side = params[:side]
    @index = params[:index].to_i
    if @side == "front"
      @album.set_default_front_cover(@index)
      @src = @album.front_cover_image.url
    else
      @album.set_default_back_cover(@index) 
      @src = @album.back_cover_image.url
    end
    rescue CannotFindCover
      @errors = true
    end
  end
  
  def create
    begin
      @artist = Artist.find(params[:artist_id])
      @album = Album.find(params[:album_id])
      @album.set_covers_from_urls(params[:front_cover_url], params[:back_cover_url])
    rescue CannotFindAlbum
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
  
  def block
  end
  
  def index
    # if request.remote_ip == "98.175.24.253"
    #   impressionist(Track.first)
    #   redirect_to block_albums_path
    # end
    @current_page = params[:page].to_i
    @current_page = 1 unless params[:page].present?
    @albums = Album.where(in_collection: true).where("albums.back_cover_image_file_size > ?", 0).where("albums.front_cover_image_file_size > ?", 0).paginate(:page => @current_page, :per_page => 10).order('created_at DESC')
    @current_page -= 1 if @albums.empty?
  end
  
end

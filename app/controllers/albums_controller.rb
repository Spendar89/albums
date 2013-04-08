class AlbumsController < ApplicationController
  include Youtube
  
  def new
    @album = Album.new
  end
  
  def preview
    begin
    @artist = Artist.find_or_create_by_name(:name => params[:artist_name][0])
    if @artist.id
      @album = @artist.set_album(params[:title][0])
      @album.title
      @album.set_default_covers
    else
      flash[:notice] = "Cannot Find Artist"
      redirect_to new_album_path and return
    end
    rescue CannotFindAlbum, CannotFindCover => e
      if e == CannotFindAlbum
        flash[:notice] = "Cannot Find Album"
        redirect_to new_album_path and return
      end
    end
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
  
  def index
    @albums = Album.where(in_collection: true).order(:created_at).reverse
  end
end

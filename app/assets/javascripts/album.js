function clearOtherAlbums(){
	$('.play-track').each(function(){
		$(this).data("playing", false);
		$(this).data("loaded", false);
		$(this).removeClass('icon-pause').addClass('icon-play');
		$('#lcd-position').text("01");
	});
}

function Album(tracks, title, artist, description, player){
  clearOtherAlbums();
  this.tracks = tracks
  this.title =  title
  this.artist = artist
  this.description = description
  this.player = player
  this.paused = false
  this.playing = false
  this.loaded = false
  this.currentTrack = new Track(this.tracks[0], 0)
  this.domSelector = $("i[data-title='"+title+"']");
}

Album.prototype.loadTrack = function(){
  this.player.loadVideoById(this.currentTrack.yt_id);
  this.domSelector.data("loaded", true);
  this.loaded = true;
  $.get("/tracks/"+this.currentTrack.yt_id+"/count_play");
}

Album.prototype.playTrack = function(){
  this.playing = true;
  this.domSelector.data("playing", true);
  if(this.paused == true){
    this.pauseTrack();
  }else{
    this.domSelector.removeClass('icon-play').addClass('icon-pause');
  }
}

Album.prototype.pauseTrack = function(){
  this.paused = true
  this.playing = false;
  this.domSelector.data("playing", false);
  this.domSelector.removeClass('icon-pause').addClass('icon-play');
  this.player.pauseVideo();
}

Album.prototype.unPauseTrack = function(){
  this.paused = false
  this.player.playVideo();
}

Album.prototype.nextTrack = function(){
  this.playing = false;
  this.loaded = false;
  var currentPosition = this.currentTrack.position
  if(currentPosition < this.tracks.length - 1){
    this.currentTrack = new Track(this.tracks[currentPosition + 1], currentPosition + 1);
  }else{
    this.currentTrack = new Track(this.tracks[0], 0);
  }
  this.loadTrack();
}

Album.prototype.prevTrack = function(){
  this.playing = false;
  this.loaded = false;
  var currentPosition = this.currentTrack.position
  if(currentPosition > 0){
    this.currentTrack = new Track(this.tracks[currentPosition - 1], currentPosition - 1);
  }else{
    this.currentTrack = new Track(this.tracks[this.tracks.length - 1], this.tracks.length - 1);
  }
  this.loadTrack();
}

function Track(yt_id, position){
  this.yt_id = yt_id
  this.position = position
}
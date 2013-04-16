
var tag = document.createElement('script');
tag.src = "//www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '250',
    width: '250',

	playerVars: {
	                'html5': 1,
                  'autoplay': 1
	            },
    events: {
    'onReady': onPlayerReady,
    'onStateChange': onPlayerStateChange
    }
  });
}

function loadAlbum(play_button, player){
  var title = play_button.data("title");
  var artist = play_button.data("artist");
  var description = play_button.data("description");
  var tracks = play_button.data("tracks-array");
  $('.now-playing-div h5').text(artist + "-" + title);
  $('.now-playing-div .description-div p').text(description);
  album = new Album(tracks, title, artist, description, player);
  album.loadTrack();
}

function onPlayerReady(event) {
	var player = event.target;
	stopWatch = new StopWatch();
	$('.play-track').click(function(){
		if($(this).data("playing") == false){
			if($(this).data("loaded") == false){
				loadAlbum($(this), player);
			}else{
			  album.unPauseTrack();
			}
		}else{
      album.pauseTrack();
		}
	});
	
	$(".next-track").click(function(){
    album.nextTrack();
	});
  
  $(".prev-track").click(function(){
    album.prevTrack();
  });
  
  $(".next-track, .prev-track").click(function(){
    var trackIndex = album.currentTrack.position
    if(trackIndex < 9 && trackIndex > 0){
		  $('#lcd-position').text("0"+(trackIndex + 1));
    }else if(trackIndex >= 9 && trackIndex < album.tracks.length ){
      $('#lcd-position').text(trackIndex + 1);
    }else{
      $('#lcd-position').text("01");
    }
  });
	
}

function onPlayerStateChange(event) {        
    if(event.data === 0) {
      stopWatch.restart();          
      $('.icon-pause').siblings('.next-track').trigger('click');
    }    
    if(event.data === 1){
      album.playTrack();
      stopWatch.start();
    }    
    if(event.data === 2){
      stopWatch.pause();
    }    
    if(event.data === -1){
      stopWatch.restart();
    }
}

function rotateAlbums(){
	$('.cube').each(function(){
		var posOrNeg = Math.random() < 0.5 ? -1 : 1;
		var amount = Math.floor(Math.random()*3*posOrNeg);
		$(this).css('-webkit-transform', 'rotate('+amount+'deg) translateZ( -200px )');
 	})
}

function flipAlbums(){
  $('.front-play-track').click(function(){
    $('.flipped').removeClass('flipped');
    var cube = $(this).parents('.cube');
    var back = cube.children('.back');
    back.children('.controls-div').children('.play-track').trigger('click');
    back.addClass('show-back');
    cube.addClass('flipped');
  });
}

function hoverPlayIcon(){
  $(".invisible-overlay").hover(function(){
    $(this).children(".front-play-track").css('visibility', 'visible');
  }, function(){
    $(this).children(".front-play-track").css('visibility', 'hidden');
  });
}

function setAlbumsDivHeight(){
  $('.albums-div').css('height', $(window).height());
}

$(document).ready(function(){
  flipAlbums();
  hoverPlayIcon();
  setAlbumsDivHeight();
  $(window).resize(function(){
    setAlbumsDivHeight();
  });
})

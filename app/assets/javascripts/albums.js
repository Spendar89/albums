// 2. This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');

// This is a protocol-relative URL as described here:
//     http://paulirish.com/2010/the-protocol-relative-url/
// If you're testing a local page accessed via a file:/// URL, please set tag.src to
//     "https://www.youtube.com/iframe_api" instead.
tag.src = "//www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '250',
    width: '250',

	playerVars: {
	                'html5': 1
	            },
    events: {
      'onReady': onPlayerReady,
    'onStateChange': onPlayerStateChange
    }
  });
}

// 4. The API will call this function when the video player is ready.
function onPlayerReady(event) {
	var player = event.target;
	stopWatch = new StopWatch();
	$('.play-track').click(function(){
    var title = $(this).data("title");
    var artist = $(this).data("artist");
    var description = $(this).data("description");
    $('.now-playing-div h5').text(artist + "-" + title);
    $('.now-playing-div .description-div p').text(description);
		if($(this).data("playing") == false){
			if($(this).data("loaded") == false){
				$('.play-track').each(function(){
					$(this).data("playing", false);
					$(this).data("loaded", false);
					$(this).removeClass('icon-pause').addClass('icon-play');
					$('#lcd-position').text( "01");
				});
				stopWatch.restart();
				var tracksArray = $(this).data('tracks-array');
				yt_id = tracksArray[0]
				player.loadVideoById(yt_id);
        $.get("/tracks/"+yt_id+"/count_play")
				$(this).data("loaded", true);	
			};
			$(this).removeClass('icon-play').addClass('icon-pause');
			stopWatch.play();
			player.playVideo();
			$(this).data("playing", true);
		}else{
			$(this).data("playing", false);
			$(this).removeClass('icon-pause').addClass('icon-play');
			player.pauseVideo();
			stopWatch.pause();
		}
	});
	
	$(".next-track").click(function(){
		var playButton = $(this).siblings('.play-track');
		var tracksArray = playButton.data('tracks-array');
		var trackIndex = playButton.data('position') + 1;
    if(trackIndex < 9 && trackIndex > 0){
		  $('#lcd-position').text("0"+(trackIndex + 1));
      playButton.data('position', trackIndex);
    }else if(trackIndex >= 9 && trackIndex < parseInt(playButton.data('max-tracks'))){
      $('#lcd-position').text(trackIndex + 1);
       playButton.data('position', trackIndex);
    }else{
			trackIndex = 0;
      $('#lcd-position').text("01");
			playButton.data('position', trackIndex);
    }
    stopWatch.restart();
		var nextYtId = tracksArray[trackIndex]
    if(player.getPlayerState() == 2){
      player.loadVideoById(nextYtId);
      $.get("/tracks/"+nextYtId+"/count_play")
      player.pauseVideo();
      playButton.data("playing", false);
      stopWatch.pause();
      playButton.removeClass('icon-pause').addClass('icon-play');
    }else{
  		player.loadVideoById(nextYtId);
      $.get("/tracks/"+nextYtId+"/count_play")
      playButton.data("playing", true);
      stopWatch.play();
      playButton.removeClass('icon-play').addClass('icon-pause');
    }
	})
	
	$(".prev-track").click(function(){
		var playButton = $(this).siblings('.play-track');
		var tracksArray = playButton.data('tracks-array');
		var trackIndex = playButton.data('position') - 1;
    if(trackIndex <= 9 && trackIndex > 0){
		  $('#lcd-position').text("0"+(trackIndex + 1));
      playButton.data('position', trackIndex );
    }else if(trackIndex > 9 && trackIndex < parseInt(playButton.data('max-tracks'))){
      $('#lcd-position').text((trackIndex + 1));
      playButton.data('position', trackIndex );
    }else{
			trackIndex = 0;
      $('#lcd-position').text("01");
			playButton.data('position', trackIndex);
    }
		stopWatch.restart();
		var prevYtId = tracksArray[trackIndex]
    if(player.getPlayerState() == 2){
      player.loadVideoById(prevYtId);
      $.get("/tracks/"+prevYtId+"/count_play")
      player.pauseVideo();
      playButton.data("playing", false);
      stopWatch.pause();
      playButton.removeClass('icon-pause').addClass('icon-play');
    }else{
  		player.loadVideoById(prevYtId);
      $.get("/tracks/"+prevYtId+"/count_play");
      playButton.data("playing", true);
      stopWatch.play();
      playButton.removeClass('icon-play').addClass('icon-pause');
    } 
	})
}



// 5. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
var done = false;
function onPlayerStateChange(event) {        
    if(event.data === 0) {          
      $('.icon-pause').siblings('.next-track').trigger('click');
    }
}
function stopVideo() {
  player.stopVideo();
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
    // $('.show-back').removeClass('show-back');
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

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

function stopWatch(){
	var mins = 0;
	var secs = 0;
	var minsCounter;
	var secsCounter;
	
	this.restart = function(){
		mins = 0;
		secs = 0;
		$("#lcd-minutes").text("00");
		$("#lcd-seconds").text("00");
		clearInterval(minsCounter);
		clearInterval(secsCounter);
	};

	
	this.startMins = function(){
		minsCounter = setInterval(function() {
			mins += 1;
			$("#lcd-minutes").text("0" + mins);
		}, 60000);
	};
	
	this.startSecs = function(){
		secsCounter = setInterval(function(){
			secs += 1;
			if(secs < 10){
				$("#lcd-seconds").text("0" + secs);
			}else if(secs > 59){
				$("#lcd-seconds").text("00");
				secs = 0
			}else{
				$("#lcd-seconds").text(secs);
			}
		}, 1000);
	};
	
	this.pause = function(){
		clearInterval(minsCounter);
		clearInterval(secsCounter);
	};
}

// 4. The API will call this function when the video player is ready.
function onPlayerReady(event) {
	var player = event.target;
	trackStopWatch = new stopWatch();
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
				trackStopWatch.restart();
				var tracksArray = $(this).data('tracks-array');
				yt_id = tracksArray[0]
				player.loadVideoById(yt_id);
				$(this).data("loaded", true);	
			};
			$(this).removeClass('icon-play').addClass('icon-pause');
			trackStopWatch.pause();
      trackStopWatch.startSecs();
			trackStopWatch.startMins();
			player.playVideo();
			$(this).data("playing", true);
		}else{
			$(this).data("playing", false);
			$(this).removeClass('icon-pause').addClass('icon-play');
			player.pauseVideo();
			trackStopWatch.pause();
		}
	});
	
	$(".next-track").click(function(){
		var playButton = $(this).siblings('.play-track');
		var tracksArray = playButton.data('tracks-array');
		var trackIndex = playButton.data('position');
		playButton.data('position', trackIndex + 1);
		trackIndex += 1
		$('#lcd-position').text("0"+(trackIndex + 1));
		trackStopWatch.restart();
		if(trackIndex > tracksArray.length - 1){
      trackStopWatch.restart();
      return 
			trackIndex = tracksArray.length - 1;
			playButton.data('position', trackIndex);
		}
		var nextYtId = tracksArray[trackIndex]
    if(player.getPlayerState() !== 1){
      player.loadVideoById(nextYtId);
      player.pauseVideo();
      playButton.data("playing", false);
      trackStopWatch.pause();
    }else{
  		player.loadVideoById(nextYtId);
      trackStopWatch.pause();
  	  trackStopWatch.startSecs();
  	  trackStopWatch.startMins();
    }
	})
	
	$(".prev-track").click(function(){
		var playButton = $(this).siblings('.play-track');
		var tracksArray = playButton.data('tracks-array');
		var trackIndex = playButton.data('position') - 1;
		playButton.data('position', trackIndex );
		$('#lcd-position').text("0"+(trackIndex + 1));
		trackStopWatch.restart();
		if(trackIndex < 0){
			trackIndex = 0;
			playButton.data('position', trackIndex);
		}
		var prevYtId = tracksArray[trackIndex]
    if(player.getPlayerState() !== 1){
      player.loadVideoById(prevYtId);
      player.pauseVideo();
      playButton.data("playing", false);
      trackStopWatch.pause();
    }else{
  		player.loadVideoById(prevYtId);
      trackStopWatch.pause();
  	  trackStopWatch.startSecs();
  	  trackStopWatch.startMins();
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

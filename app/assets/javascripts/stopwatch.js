function StopWatch(){
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
  
  this.start = function(){
    clearInterval(minsCounter);
    clearInterval(secsCounter);
    this.startMins();
    this.startSecs();
  }
}

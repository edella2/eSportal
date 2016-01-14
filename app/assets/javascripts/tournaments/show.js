$(document).ready(function(){
  subscribeCalendar();
  getTimeRemaining(deadline);
  initializeClock('clockdiv', deadline);
  subscribeText();
});

function subscribeText(){
  $('#sub_text').click(function() {
    $('#sub_text').text("Subscribed");
  })
};

function getTimeRemaining(endtime){
  var t = Date.parse(endtime) - Date.parse(new Date());
  var seconds = Math.floor( (t/1000) % 60 );
  var minutes = Math.floor( (t/1000/60) % 60 );
  var hours = Math.floor( (t/(1000*60*60)) % 24 );
  var days = Math.floor( t/(1000*60*60*24) );

  if (days > -1 ) {
      return {
      'total': t,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds
    };
  }
   else {
      return {
      'total': t,
      'days': 0,
      'hours': 0,
      'minutes': 0,
      'seconds': 0
    };
   }
}

function initializeClock(id, endtime){
  var clock = document.getElementById(id);
  var daysSpan = clock.querySelector('.days');
  var hoursSpan = clock.querySelector('.hours');
  var minutesSpan = clock.querySelector('.minutes');
  var secondsSpan = clock.querySelector('.seconds');


  function updateClock(){
    var t = getTimeRemaining(endtime);

    daysSpan.innerHTML = ('0' + t.days).slice(-2) + ' days';
    hoursSpan.innerHTML = ('0' + t.hours).slice(-2) + ':';
    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2) + ':';
    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2) ;

    if(t.total<=0){
      clearInterval(timeinterval);
    }
  }

updateClock(); // run function once at first to avoid delay
  var timeinterval = setInterval(updateClock,1000);
}


function subscribeCalendar(){
  $("button.calendar-submit").click(function(e){
    e.preventDefault();
    var route = $(this).parent().attr('action');
    $.ajax({
      url: route,
      method: 'post',
      dataType: 'json'
    }).done(function(response){
      $('#sub_text').text(response['subscribed'])
    })
  })
}


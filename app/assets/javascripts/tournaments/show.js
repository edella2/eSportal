$(document).ready(function(){
  subscribeCalendar();
});


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


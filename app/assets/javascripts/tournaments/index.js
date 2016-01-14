$(document).ready(function(){
  hoverDescription();
});


function hoverDescription(endtime){
	$('img').hover(function () {
	  var imageId = $(this).attr("id")
	  $("#" + imageId + "-default-index-text").stop().fadeOut(200, function () {
	    $("#" + imageId + "-hover-index-text").stop().fadeIn(400);
	  });
	}, function () {
	  var imageId = $(this).attr("id")
	  $("#" + imageId + "-hover-index-text").stop().fadeOut(400, function () {
	    $("#" + imageId + "-default-index-text").stop().fadeIn(600);
	  });
	});
};
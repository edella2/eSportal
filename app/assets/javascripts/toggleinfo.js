$('img').hover(function(){
    var imageId = $(this).attr("id")
    $("#"+imageId+"-default-index-text").stop( true, true).fadeOut(0, function(){
      $("#"+imageId+"-hover-index-text").stop( true, true).fadeIn();
    });
},function(){
    var imageId = $(this).attr("id")
    $("#"+imageId+"-hover-index-text").stop( true, true).fadeOut(0, function() {
      $("#"+imageId+"-default-index-text").stop( true, true).fadeIn();
    });
});
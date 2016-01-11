$('img').hover(function(){
    var imageId = $(this).attr("id")
    $("#"+imageId+"-default-index-text").fadeOut(0, function(){
      $("#"+imageId+"-hover-index-text").fadeIn();
    });
},function(){
    var imageId = $(this).attr("id")
    $("#"+imageId+"-hover-index-text").fadeOut(200, function() {
      $("#"+imageId+"-default-index-text").fadeIn();
    });
});
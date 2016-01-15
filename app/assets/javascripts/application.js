// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require bootstrap.min
//= require google_analytics
//= require_tree .
//= require bootstrap


function onKonamiCode(fn) {
  var codes = (function(){
          var c = [38,38,40,40,37,39,37,39,66,65];
          onKonamiCode.requireEnterKey && c.push(13);
          return c;
      })(),
      expecting = function(){
          expecting.codes = expecting.codes || Array.apply({}, codes);
          expecting.reset = function() { expecting.codes = null; };
          return expecting.codes;
      },
      handler = function(e) {
          if (expecting()[0] == (e||window.event).keyCode) {
              expecting().shift();
              if (!expecting().length) {
                  expecting.reset();
                  fn();
              }
          } else { expecting.reset(); }
      };
  window.addEventListener ?
      window.addEventListener('keydown', handler, false)
      : document.attachEvent('onkeydown', handler);
}

onKonamiCode.requireEnterKey = false; // True/false
onKonamiCode(function(){
alert("KONAMI CODE!\nHere's a game made by a CSS wizard" );
window.location = "http://gastongouron.github.io/game/index.html"
});
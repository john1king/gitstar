// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery.waypoints
//= require_tree .

$(function(){
  var $container = $('#repos')
  var $repos = $('#repos ul');
  var opts = {
    context: $container,
    offset: 'bottom-in-view'
  }
  var onscroll = function(direction){
    if (direction == 'up') return;
    var $next = $container.find('.next');
    if ($next.length){
      var url = $next.attr('href');
      $container.append('<div class="spinner"></div>');
      $next.remove();
      $.ajax({
        url: url,
        dataType: 'script',
        success: function(){
          $repos.waypoint(onscroll, opts);
        }
      });
    }
    this.destroy()
  }
  $repos.waypoint(onscroll, opts);
});


;(function($){
  $.fn.focusEnd = function(){
    var $input = $(this);
    var strLength= $input.val().length;
    $input.focus();
    $input[0].setSelectionRange(strLength, strLength);
  };

  $.fn.infiniteScroll = function(context){
    var $container = $(context);
    var self = this;
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
            self.waypoint(onscroll, opts);
          }
        });
      }
      this.destroy()
    }
    Waypoint.destroyAll();
    self.waypoint(onscroll, opts);
  };
})(jQuery);

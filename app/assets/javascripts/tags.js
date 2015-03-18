;$(function(){

  $('#tags').on('keyup', 'li', function(e){
    // type ESC
    if(e.keyCode == 27){
      var $self = $(this);
      var $origin = $self.find('.origin');
      if ($origin.length){
       $self.html($origin.html());
      } else if ($self.hasClass('new-tag')){
        $self.remove()
      }
    }
  })

})();

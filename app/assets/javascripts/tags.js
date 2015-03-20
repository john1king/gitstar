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
  });

  // drag star to add tag
  $('#stars').on('dragstart', 'li', function(e){
    e.originalEvent.dataTransfer.setData('star-id', $(this).data('star-id'));
  });

  $('#tags')
    .on('dragover', 'li', function(e) {
      e.preventDefault();
      e.originalEvent.dataTransfer.dropEffect = 'move';
    })
    .on('dragenter', 'li', function(e) {
      e.preventDefault();
    })
    .on('drop', 'li', function(e){
      e.preventDefault();
      var oe = e.originalEvent;
      var star_id = oe.dataTransfer.getData('star-id');
      var $target = $(oe.target);
      if (!$target.is('li')){
        $target = $target.parents('li');
      }
      var tag_id = $target.attr('id').split('-')[1];
      $.ajax({
        method: 'POST',
        url: '/tags/' + tag_id + '/add_star?star_id=' + star_id,
        dataType: 'script'
      });
    });
});

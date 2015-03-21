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
  var stop_drag = false;
  var $target;
  var $pre_target;
  var dragged_tags = [];
  var dragged_star_id;

  $('#stars').on('dragstart', 'li', function(e){
    var orig_event = e.originalEvent;
    dragged_star_id = $(this).data('star-id');
    dragged_tags = $(this).find('.tag').map(function(){ return $(this).text() }).get();
  });

  $('#tags')
    .on('dragenter', 'li', function(e){
      var orig_event = e.originalEvent;
      $pre_target = $target;
      $target = $(orig_event.target);
      if (!$target.is('li')){
        $target = $target.parents('li');
      }
      var tag_name = $target.find('.tag').contents()[1].nodeValue;
      stop_drag = $.inArray(tag_name, dragged_tags) > 0;
      if (!stop_drag){
        $target.addClass('dropable');
        $target.find('.counter').text(+ $target.find('.counter').text() + 1);
      }
    })
    .on('dragover', 'li', function(e) {
      if (!stop_drag){
        e.preventDefault();
        e.originalEvent.dataTransfer.dropEffect = 'move';
      }
    })
    .on('dragleave', 'li',function(e){
      var $leave_target;
      if ($pre_target){
        $leave_target = $pre_target;
        $pre_target = null;
      } else if (!stop_drag) {
        $leave_target = $target;
        $target = null;
      }
      if ($leave_target) {
        $leave_target.removeClass('dropable');
        $leave_target.find('.counter').text(+ $leave_target.find('.counter').text() - 1);
      }
    })
    .on('drop', 'li', function(e){
      var orig_event = e.originalEvent;
      var tag_id = $target.attr('id').split('-')[1];
      $.ajax({
        method: 'POST',
        url: '/tags/' + tag_id + '/add_star?star_id=' + dragged_star_id,
        dataType: 'script'
      });
      $target = null;
    });
});

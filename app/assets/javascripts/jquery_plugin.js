(function($){
  $.fn.focusEnd = function(){
    var $input = $(this);
    var strLength= $input.val().length;
    $input.focus();
    $input[0].setSelectionRange(strLength, strLength);
  }
})(jQuery);




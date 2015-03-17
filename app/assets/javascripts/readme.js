$(function(){
  $('#repos').on('click', 'li', function(){
    var $li = $(this);
    $.ajax({
      url: $li.data('readme-url'),
      dataType: 'script',
      success: function(){
        console.log('success!')
      }
    })
  });
});

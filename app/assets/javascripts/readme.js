$(function(){
  var lastReadmeUrl;
  $('#stars').on('click', 'li', function(){
    var $li = $(this);
    var readmeUrl = $li.data('readme-url');
    if (lastReadmeUrl != readmeUrl){
      lastReadmeUrl = readmeUrl;
      $.ajax({
        url: readmeUrl,
        dataType: 'script'
      })
    }
  });
});

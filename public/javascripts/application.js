// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var friend_elements = []

$().ready(function() {
  if (typeof(authentications) == 'object') {
    $.each(authentications, function(key, value) {
      $('#connections li.' + value).remove();
      $('#signout').show();
    });
  }
  if (typeof(friends) == 'object') {
    $('#svg_intro').height(Math.ceil(friends.length / 20) * 52 + 2 + 'px').width('1042px').svg({onLoad: drawIntro});
  }
})

function drawIntro(svg) {
  var i = 0;
  var height = 2;
  $.each(friends, function(key, value) {
    var link = svg.link(value.link);
    svg.title(link, value.name);
    svg.image(link, i * 52 + 2, height, 50, 50, value.photo);
    i = i + 1;
    if (i == 20) {
      i = 0;
      height = height + 52;
    }
  });
}
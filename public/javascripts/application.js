// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var friend_elements = []
var count_line = 10;

$().ready(function() {
  if (typeof(authentications) == 'object') {
    $.each(authentications, function(key, value) {
      $('#connections li.' + value.provider).html('подключен к ' + value.provider + ' как ' + value.uid);
    });
    $('#signout_link, #refresh_link').show();
  }
  if (typeof(friends) == 'object') {
    $('#share_link, #count_line, #refresh_svg_link').show();
    refresh_svg();
  }
})

function drawIntro(svg) {
  var i = 0;
  var height = 2;
  var element = $('#svg_intro');
  var canva = svg.rect(0, 0, element.width(), element.height(), {fill: 'black'});
  $.each(friends, function(key, value) {
    var link = svg.link(value.link);
    svg.title(link, value.name);
    svg.image(link, i * 52 + 2, height, 50, 50, value.photo, {fill: 'green'});
    i = i + 1;
    if (i == count_line) {
      i = 0;
      height = height + 52;
    }
  });
  svg.text(element.width() - 135, element.height() - 5, 'myfriendscollage.ru', {fill: 'white'});
}

function refresh_svg() {
  var line_items = $('#count_line').val();
  count_line = isNaN(parseInt(line_items)) ? 20 : parseInt(line_items);
  $('#svg_intro').removeClass('hasSVG').html('');
  $('#svg_intro').height(Math.ceil(friends.length / count_line) * 52 + 2 + 'px').width(count_line * 52 + 2 + 'px').svg({onLoad: drawIntro, settings: {fill: 'green'}});
}
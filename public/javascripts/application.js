// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var friend_elements = []
var count_line = 20;
var svg_content = "";

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

// if you want use canvas add <canvas id='canvas_intro' /> and uncomment follow
// function draw_friends_svg() {
//   var element =$('#canvas_intro');
//   if (!element[0].getContext) return false;
//   var context = element[0].getContext('2d');
//   var i = 0;
//   var height = 2;
//   element.attr('height', Math.ceil(friends.length / count_line) * 52 + 2);
//   element.attr('width', count_line * 52 + 2);
//   
//   $.each(friends, function(key, value) {
//     var img = new Image();
//     
//     img.addEventListener('load', function () {
//       context.drawImage(this, i * 52 + 2, height, 50, 50);
//       i = i + 1;
//       if (i == count_line) {
//         i = 0;
//         height = height + 52;
//       }
//     });
//     
//     img.src = value.photo;
//   });
// }

function drawIntro(svg) {
  var i = 0;
  var height = 2;
  var element = $('#svg_intro');
  var canva = svg.rect(0, 0, element.width(), element.height(), {fill: 'black'});
  $.each(friends, function(key, value) {
    var link = svg.link(value.link, {prefix: 'xlink'});
    svg.title(link, value.name);
    svg.image(link, i * 52 + 2, height, 50, 50, value.photo, {'xlink:href': value.photo});
    i = i + 1;
    if (i == count_line) {
      i = 0;
      height = height + 52;
    }
  });
  svg.text(element.width() - 140, element.height() - 5, 'myfriendscollage.ru', {fill: 'white'});
  svg_content = svg.toSVG();
}

function refresh_svg() {
  var line_items = $('#count_line').val();
  count_line = isNaN(parseInt(line_items)) ? 20 : parseInt(line_items);
  var element = $('#svg_intro');
  element.removeClass('hasSVG').html('');
  element.height(Math.ceil(friends.length / count_line) * 52 + 2 + 'px').width(count_line * 52 + 2 + 'px');
  element.svg({
    onLoad: drawIntro, 
    settings: {
      xmlns: "http://www.w3.org/2000/svg",
      'xmlns:xlink': "http://www.w3.org/1999/xlink"
    }
  });
}
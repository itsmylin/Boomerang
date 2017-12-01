
$(window).load(function() { console.log("mood.js load");
  $('.post-module').hover(function() {
    $(this).find('.description').stop().animate({
      height: "toggle",
      opacity: "toggle"
    }, 300);
  });
});///

function getRandomSize(min, max) {
  return Math.round(Math.random() * (max - min) + min);
}




var allImages = "";
var num_of_moods =9;
for (var i = 1; i <= num_of_moods; i++) {
  var width = getRandomSize(200, 400);
  var height =  getRandomSize(200, 400);
  //allImages +=  '<a href="default.asp"> <img src="https://placekitten.com/'+width+'/'+height+'" alt="pretty kitty"> </a>';
  allImages +=  '<bkkutton name="action" value="blue"> <img src="assets/'+i+'.jpeg" alt="pretty kitty" style="margin:0; padding:0; width: 100%"> </button>';

}

$('#photos').append(allImages)

console.log("sssss")

function getRandomSize(min, max) {
  return Math.round(Math.random() * (max - min) + min);
}

var allImages = "";
var num_of_moods =9;
for (var i = 1; i <= num_of_moods; i++) {
  var width = getRandomSize(200, 400);
  var height =  getRandomSize(200, 400);
  //allImages +=  '<a href="default.asp"> <img src="https://placekitten.com/'+width+'/'+height+'" alt="pretty kitty"> </a>';
  allImages +=  '<a href="default.asp"> <img src="assets/'+i+'.jpeg" alt="pretty kitty"> </a>';

}
console.log("sssss2222ss")
$('#photos').append(allImages);

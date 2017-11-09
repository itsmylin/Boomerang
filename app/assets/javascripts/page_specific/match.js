// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

this.paintIt = function(element, backgroundColor, textColor) {
  element.style.backgroundColor = backgroundColor;
  if (textColor != null) {
    return element.style.color = textColor;
  }
};

(function() {
  $('#like').on('click',function() {
    if($('.card-img').length>0){
      $.ajax({
        url: "/meetUpdate",
        type: "POST",
        data: {
        primuser: $('#like').data('session'),
        secuser: $('#content > div:last').data('id'),
        interestID: $('#like').data('session2'),
        response: 'Y'
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert(textStatus);
          $('#content > div:last').remove();
        },
        success: function(data, textStatus, jqXHR) {
            $('#content > div:last').remove();
            console.log(data);
            if(data["status"]=="true"){
              $('.card-center').prepend(`<div class="card-img" data-id="${data["data"]["0"].id}" style="background-image: url('http://p3.ifengimg.com/a/2016_52/67639375285aaf5_size722_w1315_h876.jpg');"><div class="user-name"> ${data["data"]["0"].name} </div></div>`)
            } else {
              $('.card-center').prepend("<div class='no-user'>No user found</div>")
            }
        }
      });
    }
    if($('.card-img').length == 0) {
      $('#content > div:last').remove();
      $('.card-center').append("<div class='no-user'>No user found</div>")
    }
  });

  $('#dislike').on('click',function() {
      if($('.card-img').length>0){
        $.ajax({
          url: "/meetUpdate",
          type: "POST",
          data: {
          primuser: $('#like').data('session'),
          secuser: $('#content > div:last').data('id'),
          interestID: $('#like').data('session2'),
          response: 'N'
          },
          error: function(jqXHR, textStatus, errorThrown) {
            alert(textStatus);
            $('#content > div:last').remove();
          },
          success: function(data, textStatus, jqXHR) {
              $('#content > div:last').remove();
              console.log(data);
              if(data["status"]=="true"){
                $('.card-center').prepend(`<div class="card-img" data-id="${data["data"]["0"].id}" style="background-image: url('http://p3.ifengimg.com/a/2016_52/67639375285aaf5_size722_w1315_h876.jpg');"><div class="user-name"> ${data["data"]["0"].name} </div></div>`)
              } else {
                $('.card-center').prepend("<div class='no-user'>No user found</div>")
              }
          }
        });
      }
      if($('.card-img').length == 0) {
        $('#content > div:last').remove();
        $('.card-center').append("<div class='no-user'>No user found</div>")
      }
  });

  }).call(this);

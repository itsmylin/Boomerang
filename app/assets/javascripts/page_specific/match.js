// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

(function() {
// for like ajax
  $('#like').on('click',function() {
    if($('.card-img').length>0){
      var existedID;
      switch($('.card-img').length){
        case 3:
          existedID = [$('#content > div:first').data('id'),$('#content > div:first').next().data('id')];
          break;
        case 2:
          existedID = [$('#content > div:first').data('id')];
          break;
        default:
          existedID = []
      }
      $.ajax({
        url: "/match/update",
        type: "POST",
        data: { 
          primuser: $('#like').data('session'),
          secuser: $('#content > div:last').data('id'),
          interestID: $('#like').data('session2'),
          existedID: existedID,
          response: 'Y'
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert(textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          $('#content > div:last').remove();
          if(data["status"]=="true"){
            if(data["data"]["0"].avatar_file_name != null){
              $('.card-center').prepend('<div class="card-img" data-id="'+ data["data"]["0"].id+ '"'+ 'style="background-image:url('+ data["data"]["1"] + ')">' + '<div class="user-name">' + data["data"]["0"].name +'</div></div>');
            } else {
              $('.card-center').prepend('<div class="card-img" data-id="'+ data["data"]["0"].id+ '"'+ 'style="background-image:url(/assets/default_profile_image.png)"><div class="user-name">' + data["data"]["0"].name +'</div></div>');
            }
          } else {
            return;
          }
        }
      });
    }
    if($('.card-img').length == 0) {
      $('#content > div:last').remove();
      $('.card-center').append("<div class='no-user'>No user found</div>")
    }
  });
//  for the dislike ajax
  $('#dislike').on('click',function() {
      if($('.card-img').length>0){
        var existedID;
        switch($('.card-img').length){
          case 3:
            existedID = [$('#content > div:first').data('id'),$('#content > div:first').next().data('id')];
            break;
          case 2:
            existedID = [$('#content > div:first').data('id')];
            break;
          default:
            existedID = []
        }
        $.ajax({
          url: "/match/update",
          type: "POST",
          data: { 
            primuser: $('#like').data('session'),
            secuser: $('#content > div:last').data('id'),
            interestID: $('#like').data('session2'),
            existedID: existedID,
            response: 'N'
          },
          error: function(jqXHR, textStatus, errorThrown) {
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR) {
            $('#content > div:last').remove();
            if(data["status"]=="true"){
              if(data["data"]["0"].avatar_file_name != null ){
                $('.card-center').prepend('<div class="card-img" data-id="'+ data["data"]["0"].id+ '"'+ 'style="background-image:url('+ data["data"][1] + ')">' + '<div class="user-name">' + data["data"]["0"].name +'</div></div>');
              } else {
                $('.card-center').prepend('<div class="card-img" data-id="'+ data["data"]["0"].id+ '"'+ 'style="background-image:url(/assets/default_profile_image.png)"><div class="user-name">' + data["data"]["0"].name +'</div></div>');
              }
            } else {
              return;
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

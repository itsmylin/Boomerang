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
        url: "/matchUpdate",
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
            $('.card-center').append(`<div class="card-img" data-id="<%= ${data.data.id} %>" style="background-image: url(<%= ${data.data}.avatar.url(:medium) %>);"><div class="user-name"><%= ${data.data}.name  %></div></div>`)

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
        url: "/matchUpdate",
        type: "POST",
        data: {
        primuser: $('#like').data('session'),
        secuser: $('#content > div:last').data('id'),
        interestID: $('#like').data('session2'),
        response: 'N'
        },
        error: function(jqXHR, textStatus, errorThrown) {
            return alert(textStatus);
            $('#content > div:last').remove();
        },
        success: function(data, textStatus, jqXHR) {
            $('#content > div:last').remove();
            console.log(data);
            $('.card-center').append(`<div class="card-img" data-id="<%= ${data.data.id} %>" style="background-image: url(<%= ${data.data}.avatar.url(:medium) %>);"><div class="user-name"><%= ${data.data}.name  %></div></div>`)

        }
      });
    }
    if($('.card-img').length == 0) {
      $('#content > div:last').remove();
      $('.card-center').append("<div class='no-user'>No user found</div>")
    }
  });
  
  }).call(this);
  



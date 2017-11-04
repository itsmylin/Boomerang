# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor
$ = jQuery

@like = ->
  user1 = $('#like').data('session')
  user2 = $('#content > div:last').data('id')
  console.log user1, user2
  $.ajax
    url: "/matchUpdate"
    type: "POST"
    data: { primuser: user1, secuser: user2, response: 'Y' }
    error: (jqXHR, textStatus, errorThrown) ->
      alert textStatus
    success: (data, textStatus, jqXHR) ->
      console.log data
  list = document.getElementById('content')
  if list.hasChildNodes() 
    list.removeChild list.lastChild
    if !list.hasChildNodes()
      node = document.createElement('DIV')
      node.className = "no-user";
      # Create a <li> node
      textnode = document.createTextNode('No user found')
      # Create a text node
      node.appendChild textnode
      # Append the text to <li>
      document.getElementById('content').appendChild node
  return

@like = ->
  user1 = $('#like').data('session')
  user2 = $('#content > div:last').data('id')
  console.log user1, user2
  $.ajax
    url: "/matchUpdate"
    type: "POST"
    data: { primuser: user1, secuser: user2, response: 'N' }
    error: (jqXHR, textStatus, errorThrown) ->
      alert textStatus
    success: (data, textStatus, jqXHR) ->
      console.log data
    list = document.getElementById('content')
  if list.hasChildNodes() 
    list.removeChild list.lastChild
    if !list.hasChildNodes()
      node = document.createElement('DIV')
      node.className = "no-user";
      # Create a <li> node
      textnode = document.createTextNode('No user found')
      # Create a text node
      node.appendChild textnode
      # Append the text to <li>
      document.getElementById('content').appendChild node
  return

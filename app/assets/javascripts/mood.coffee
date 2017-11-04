# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).on 'resize', ->
  if $(window).height() > 500
    $('.square-sm').addClass 'square'
    $('.square-sm').removeClass 'square-sm'
  else
    $('.square').addClass 'square-sm'
    $('.square').removeClass 'square'
  return

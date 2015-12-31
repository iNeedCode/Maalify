# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$(document).on 'ready page:load', ->

  $('.datepicker-income').datepicker
    format: "dd.mm.yyyy"
    weekStart: 1
    language: "de"
    minViewMode: 1
    autoclose: true
    todayHighlight: true

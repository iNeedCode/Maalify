# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->

  $("#reporter_emails").select2
    tags: true
    placeholder: "test@example.com, test2@examaple.de"
    tokenSeparators: [',', ' ']
    multiple: true

  $("#reporter_donations").select2
    multiple: true
    minimumResultsForSearch: Infinity

  $("#reporter_tanzeems").select2
    multiple: true



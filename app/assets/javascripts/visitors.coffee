# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->


  $('#member_id_quick_select').multiselect
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    buttonWidth: '300px'
    numberDisplayed: 1

  $('#member_id_quick_select').change ->
    form_url = $(this).find(':selected').data('url')
    form = $('#quick-receipt-form')
    form.prop 'action', form_url
    form.submit()
    return

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# jQuery ready function with turbolinks
$(document).on 'ready page:load', ->
  window.onload = ->
    calculateSum()
    return

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    triggerCalculate()
    $( ".receipt-item" ).last().focus()
    event.preventDefault()

  $("#all-receipts-table").DataTable
    processing: true
    serverSide: true
    ajax: $('#all-receipts-table').data('source')
    columns: [
      {data: '0' }
      {data: '1' }
      {data: '2' }
      {data: '3' }
      {data: '4' }
      {data: '5' }
      {data: '6' }
      {data: '7' }
    ]
    autoWidth: true
    pagingType: "simple_numbers"
    "lengthMenu": [[25, 100, 200, 500], [25, 100, 200, 500]]
    stateSave: true
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

  calculateSum = ->
    sum = 0
    #iterate through each textboxes and add the values
    $('.receipt-item').each ->
      #add only if the value is number
      if !isNaN(@value) and @value.length != 0
        sum += parseFloat(@value)
      return
    #.toFixed() method will roundoff the final sum to 2 decimal places
    $('#total_sum').html sum.toFixed(2) + " €"
    return

  triggerCalculate = ->
    #iterate through each textboxes and add keyup
    $('.receipt-item').each ->
      $(this).keyup ->
        calculateSum()
        return
      return
    return

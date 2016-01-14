# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#tajnied-table").DataTable
    processing: true
    serverSide: true
    ajax: $('#tajnied-table').data('source')
    columns: [
      {data: '0' }
      {data: '1' }
      {data: '2' }
      {data: '3' }
      {data: '4' }
      {data: '5' }
      {data: '6' }
      {data: '7' }
      {data: '8' }
      {data: '9' }
      {data: '10' }
      {data: '11' }
      {data: '12' }
      {data: '13' }
      {data: '14' }
    ]
    autoWidth: true
    pagingType: "simple_numbers"
    stateSave: true
    "lengthMenu": [[25, 50, 100, 200], [25, 50, 100, 200]]
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

  $('.datepicker-member').datepicker
    format: "dd.mm.yyyy"
    weekStart: 1
    endDate: "Date.today()"
    startView: 2
    autoclose: true
    language: "de"
    orientation: "bottom auto"
    todayHighlight: true

  $('#member_plz').blur ->
    plzServiceUrl = "http://api.zippopotam.us/de/#{this.value}"
    $.get plzServiceUrl , (data) ->
      $('#member_city').val(data.places[0]["place name"])
      return

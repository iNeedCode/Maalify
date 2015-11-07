# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#tajnied-table").DataTable
    autoWidth: true
    pagingType: "simple"
    processing: true
    stateSave: true
    responsive: true
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

  $('.datepicker-member').datepicker
    format: "yyyy-mm-dd",
    weekStart: 1,
    endDate: "Date.today()",
    startView: 2,
    language: "de",
    orientation: "bottom auto",
    todayHighlight: true

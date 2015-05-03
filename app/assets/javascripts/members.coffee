# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#tajnied-table").DataTable
    autoWidth: true
    pagingType: "simple"
    processing: true
    stateSave: true
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

#    tableTools:
#      sSwfPath: "http://cdn.datatables.net/tabletools/2.2.2/swf/copy_csv_xls_pdf.swf"
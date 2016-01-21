# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#budget_selector_for_member").select2
    theme: "bootstrap"
    placeholder: "Füge dieses Mitglied zu einem Budget hinzu..."

  $("#member-all-budgets").DataTable
    autoWidth: true
    pagingType: "simple_numbers"
    stateSave: true
    "lengthMenu": [[25, 50, 100], [25, 50, 100]]
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    'sDom': 'CT<"clear">lfrtip'
    'oTableTools':
      'sSwfPath': 'http://cdn.datatables.net/tabletools/2.2.2/swf/copy_csv_xls_pdf.swf' #http://stackoverflow.com/questions/34028491/jquery-datatables-rails-tabletools-or-buttons
      'aButtons': [
        {
          "sExtends": "pdf"
          "sPdfOrientation": "landscape"
          "pageSize": "LEGAL"
        }
        'xls'
      ]
    "colVis": {
      "buttonText": "Columns"
    }


  $("#tajnied-table").DataTable
    processing: true
    serverSide: true
    ajax: $('#tajnied-table').data('source')
    columns: [
      {data: '0' }
      {data: '1' }
      {data: '2' }
      {data: '3', searchable: false }
      {data: '4', searchable: false }
      {data: '5', searchable: false }
      {data: '6' }
      {data: '7' }
      {data: '8' }
      {data: '9', searchable: false }
      {data: '10' }
      {data: '11' }
      {data: '12', searchable: false, orderable: false }
      {data: '13', searchable: false, orderable: false }
      {data: '14', searchable: false, orderable: false }
    ]
    autoWidth: true
    pagingType: "simple_numbers"
    stateSave: true
    "lengthMenu": [[25, 50, 100, 200], [25, 50, 100, 200]]
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    'sDom': 'CT<"clear">lfrtip'
    'oTableTools':
      'sSwfPath': 'http://cdn.datatables.net/tabletools/2.2.2/swf/copy_csv_xls_pdf.swf' #http://stackoverflow.com/questions/34028491/jquery-datatables-rails-tabletools-or-buttons
      'aButtons': [
        'pdf'
        'xls'
      ]
    "colVis": {
      "buttonText": "Columns"
    }

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

  if($( "#member_wassiyyat:checked").val() != "1")
    $('#wassiyyat_number_wrap').hide()

  $("#member_wassiyyat").change ->
    wassiyyatNoWrap = $('#wassiyyat_number_wrap')
    if (this.checked )
       wassiyyatNoWrap.show()
    else
       wassiyyatNoWrap.hide()


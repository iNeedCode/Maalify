# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#budget-overview").DataTable
    autoWidth: true
    pagingType: "simple_numbers"
    processing: true
    stateSave: true
    "lengthMenu": [[20, 50, 100, 500], [20, 50, 100, 500]]
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

  $("#budget-table").DataTable
    processing: true
    serverSide: true
    ajax: $('#budget-table').data('source')
    columns: [
      {data: '0' }
      {data: '1' }
      {data: '2' }
      {data: '3' }
      {data: '4' }
      {data: '5' }
      {data: '6', searchable: false, orderable: false }
      {data: '7', searchable: false, orderable: false }
      {data: '8', searchable: false, orderable: false }
    ]
    autoWidth: true
    pagingType: "simple_numbers"
    stateSave: true
    "lengthMenu": [[25, 100, 200, 500], [25, 100, 200, 500]]
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

  $('#budget-table').on 'draw.dt', ->
    $('span').tooltip({
      'placement': 'bottom',
      delay: { "bottom": 2, "hide": 100 }
    });


  $('#budget_member_id').multiselect
    includeSelectAllOption: true,
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    buttonWidth: '380px'
    numberDisplayed: 2

  $("#member_select_fields").hide() if $("#budget_donation_id").val() == ""

  FilterMembers = (organization) ->
    $.get "/members/get_all_members.json", (data) ->
      options = ""
      for key of data
        if data[key].tanzeem == organization || organization == "All"
          options += "<option value='#{data[key].id}'> #{data[key].full_name}</option> "
      $("#budget_member_id").html(options)
      $('#budget_member_id').multiselect('rebuild');

      param = location.search
      if param != ""
        myRegexp = /_id=(.*)/
        member_id_param = param.match(myRegexp)[1]
        $('#budget_member_id').multiselect('select', [member_id_param])

      if options != ""
        $("#member_select_fields").show()
      return
    return

  $("#budget_donation_id").change ->
    $('#budget_member_id').hide().empty().multiselect('rebuild')
    donation_id = $("#budget_donation_id option:selected").val()
    $.get "/donations/#{donation_id}.json", (data) ->
      FilterMembers data.organization
      return

  $("#budget_donation_id").trigger("change");
  $("#budget_selector_for_member").change ->
    numberPattern = /\d+/g;
    budget_title = this.options[this.selectedIndex].value
    member_id = location.pathname.match(numberPattern).toString()
    window.location.href = Routes.new_with_parameter_budgets_path(
      'budget_title': budget_title,
      'member_id': member_id)


  $(".none_payer_check_box").change ->
    fieldMemberData = $(this).data("member-preview")
    fieldPromiseId = $(this).data("promise")
    fieldDescriptionWrapper = $(this).data("description")

    fieldRestPromiseId = $(this).data("rest-promise-from-past-budget")
    fieldMember = $("div").find("\[data-#{fieldMemberData}=#{fieldMemberData}\]")[0]
    fieldMemberWrap = $("div").find("\[data-#{fieldMemberData}=#{fieldMemberData}\]")

    if ( this.checked )
      fieldMemberWrap.hide()
      $("#" + fieldDescriptionWrapper).show()
      fieldPromiseValue = $("#" + fieldPromiseId).val()
      fieldRestPromiseValue = $("#" + fieldRestPromiseId).val()
      $.data(fieldMember, "fieldPromiseValue", fieldPromiseValue)
      $.data(fieldMember, "fieldRestPromiseValue", fieldRestPromiseValue)
      $("#" + fieldPromiseId).val(0)
      $("#" + fieldRestPromiseId).val(0)
    else
      fieldMemberWrap.show()
      $("#" + fieldDescriptionWrapper).hide()
      fieldPromiseValue = $.data(fieldMember, "fieldPromiseValue")
      fieldRestPromiseValue = $.data(fieldMember, "fieldRestPromiseValue")
      $("#" + fieldPromiseId).val(fieldPromiseValue)
      $("#" + fieldRestPromiseId).val(fieldRestPromiseValue)


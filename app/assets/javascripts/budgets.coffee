# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#budget-table").DataTable
    autoWidth: true
    pagingType: "simple"
    processing: true
    stateSave: true
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

  $('#budget_member_id').multiselect
    includeSelectAllOption: true,
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    buttonWidth: '380px'
    numberDisplayed: 2

  $("#member_select_fields").hide() if $("#budget_donation_id").val() == ""

  FilterMembers = (organization) ->
    $.get "/members.json", (data) ->
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
    console.log(location.pathname)
    window.location.href = Routes.new_with_parameter_budgets_path(
      'budget_title': budget_title,
      'member_id': member_id)


  $(".none_payer_check_box").change ->
    fieldMemberData = $(this).data("member-preview")
    fieldPromiseId = $(this).data("promise")
    fieldRestPromiseId = $(this).data("rest-promise-from-past-budget")
    fieldMember = $("div").find("\[data-#{fieldMemberData}=#{fieldMemberData}\]")[0]
    fieldMemberWrap = $("div").find("\[data-#{fieldMemberData}=#{fieldMemberData}\]")

    if ( this.checked )
      fieldMemberWrap.hide()
      fieldPromiseValue = $("#" + fieldPromiseId).val()
      fieldRestPromiseValue = $("#" + fieldRestPromiseId).val()
      $.data(fieldMember, "fieldPromiseValue", fieldPromiseValue)
      $.data(fieldMember, "fieldRestPromiseValue", fieldRestPromiseValue)
      $("#" + fieldPromiseId).val(0)
      $("#" + fieldRestPromiseId).val(0)
    else
      fieldMemberWrap.show()
      fieldPromiseValue = $.data(fieldMember, "fieldPromiseValue")
      fieldRestPromiseValue = $.data(fieldMember, "fieldRestPromiseValue")
      $("#" + fieldPromiseId).val(fieldPromiseValue)
      $("#" + fieldRestPromiseId).val(fieldRestPromiseValue)


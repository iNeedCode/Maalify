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

  $('#budget_member_id').multiselect();
  $("#member_select_fields").hide()

  FilterMembers = (organization) ->
    $.get "/members.json", (data) ->
      options = ""
      for key of data
        if data[key].tanzeem == organization
          options += "<option value='#{data[key].id}'> #{data[key].full_name}</option> "
      $("#budget_member_id").html(options)
      $('#budget_member_id').multiselect('rebuild');
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

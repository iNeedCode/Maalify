# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  $("#donation-table").DataTable
    autoWidth: true
    pagingType: "simple"
    processing: true
    stateSave: true
    language:
      url: "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/German.json"
    dom: 'C<"clear">lfrtip'

  $("#formula_fields").hide()

  updateMinimumLabel = (bool) ->
    if bool == true
      $("#minimum_budget_fields label").text("Minumum Budget")
    else
      $("#minimum_budget_fields label").text("Budget / Versprechen")

  $(document).ready updateMinimumLabel

  $("#donation_budget").change ->
    if $("#donation_budget").is(":checked")
      $("#formula_fields").show()
      $("#donation_formula").val('')
      updateMinimumLabel(true)
    else
      $("#formula_fields").hide()
      $("#donation_formula").val('')
      updateMinimumLabel(false)




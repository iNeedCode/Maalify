# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $("#tajnied-table").DataTable
    
    # ajax: ...,
    dom: "C<\"clear\">lfrtip"
    autoWidth: true
    # pagingType: "full_numbers"
    processing: true
    tableTools:
      sSwfPath: "/swf/copy_csv_xls_pdf.swf"



# 

# Optional, if you want full pagination controls.
# Check dataTables documentation to learn more about available options.
# http://datatables.net/reference/option/pagingType
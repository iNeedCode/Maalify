// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.colVis
//= require dataTables/extras/dataTables.tableTools
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap-sprockets
//= require bootstrap-multiselect
//= require js-routes
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.de.js
//= require dataTables/extras/dataTables.responsive
//= require_tree .


$(document).on('ready page:load', function() {

    $('span').tooltip({
    	'placement': 'right',
			delay: { "show": 1, "hide": 100 }
    });

    //https://silviomoreto.github.io/bootstrap-select/
    $('.selectpicker').selectpicker();

    $(document).ready(function(){
        $('.datepicker').datepicker({
            format: "dd.mm.yyyy",
            weekStart: 1,
            language: "de",
            autoclose: true,
            orientation: "bottom auto",
            todayHighlight: true
        });
    });
});

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


//= require backend/jquery-ui.multidatespicker
//= require backend/jquery.timePicker.min

$(document).ready(function() {
    $(".input_time").timePicker({ startTime: "5:00", endTime: "19:00", step: 60});
    if ($("#multiple_date_select").length > 0){
	var current_dates = [];
	var start_date = "";
	var end_date = "";
	$.getJSON(window.location.pathname + ".json", function (json_data) {
	    $('#multiple_date_select').multiDatesPicker({
		numberOfMonths: 3,
		dateFormat: 'mm/dd/yy',
		altField: '#meeting_dates',
		addDates: json_data.meeting_dates,
		minDate: json_data.start_date,
		maxDate: json_data.end_date
	    });
	});
    }
});
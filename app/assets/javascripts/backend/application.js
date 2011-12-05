// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


//= require backend/jquery-ui.multidatespicker
//= require backend/jquery.timePicker.min
//= require backend/location

$(document).ready(function() {
    $(".input_time").timePicker({ startTime: "5:00", endTime: "19:00", step: 60});
    if ($("#multiple_date_select").length > 0) {
        var current_dates = [];
        var start_date = "";
        var end_date = "";
        var options = {};
        $.getJSON(window.location.pathname + ".json", function (json_data) {
            options.numberOfMonths = 3;
            options.dateFormat = 'mm/dd/yy';
            options.altField = '#meeting_dates';
            options.minDate = json_data.start_date;
            options.maxDate = json_data.end_date;
            if (json_data.meeting_dates.length > 0) {
                options.addDisabledDates = json_data.meeting_dates;
            }
            $('#multiple_date_select').multiDatesPicker(options);
        });
        $(".del_button").click( function() {
            $('#multiple_date_select').datepicker('refresh');
        })
    }
});
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require backend/jquery.timePicker.min
//= require backend/jquery-ui-timepicker-addon
//= require backend/jquery-ui.multidatespicker

//= require backend/location

// should we add gcal ?

$(function (){
    $(".datepicker").datepicker({ dateFormat: 'D, dd M yy' });
    $(".datetimepicker").datetimepicker({ dateFormat: 'D, dd M yy' });
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

jQuery.fn.delay = function(time,func){
    return this.each(function(){
        setTimeout(func,time);
    });
};


//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require backend/jquery.timePicker.min
//= require backend/jquery-ui-timepicker-addon
//= require backend/jquery-ui.multidatespicker
//= require backend/bootstrap-alert
//= require backend/bootstrap-tab

//= require backend/location

// should we add gcal ?

$(function (){
//    $(".alert-message").alert();
    $("#user_edit_tabs").tab('show');
    $(".datepicker").datepicker({ dateFormat: 'D, dd M yy' });
    $(".datetimepicker").datetimepicker({ dateFormat: 'D, dd M yy' });
    $(".input_time").timePicker({ startTime: "5:00", endTime: "19:00", step: 60});
    $(".fit_wit_workout").change(function () {
        var workout_id = $(this).val();
        var select_field = $(this);
        var s_id = select_field.attr("id");
            $.getJSON('/backend/fit_wit_workouts/' + workout_id + '.json', function(data){
                if ($("#e_" + s_id).length == 0) {
                  select_field.parent().append("<div id='e_" + s_id + "'></div>");
                }
                $("#e_" + s_id).html("<b>Units:</b> " + data.score_method + "<br><b>Description:</b> " + data.description + "</div>");
            })
        })
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


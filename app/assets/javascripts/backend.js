//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.validate.min
//= require backend/jquery.timePicker.min
//= require backend/jquery-ui-timepicker-addon
//= require backend/jquery-ui.multidatespicker
//= require backend/bootstrap.min

//= require backend/location
//= require backend/manage_workouts

// should we add gcal ?

// setup defaults for $.validator outside domReady handler
$.validator.setDefaults({
    highlight: function (element) {
        $(element).closest(".control-group").addClass("error");
    },
    unhighlight: function (element) {
        $(element).closest(".control-group").removeClass("error");
    }
});

jQuery.validator.addMethod("greaterThan",
function(value, element, params) {
    if (!/Invalid|NaN/.test(new Date(value))) {
        return new Date(value) > new Date($(params).val());
    }

    return isNaN(value) && isNaN($(params).val())
        || (parseFloat(value) > parseFloat($(params).val()));
},'Must be greater than the start date.');


$(function () {
//    $(".alert-message").alert();
    $(".alert").alert();
    $("#user_edit_tabs").tab('show');
    $(".event_form").validate({
      rules: {
        "event[starts_at]": {
          required: true,
          date: true
        },
        "event[ends_at]": {
          required: true,
          date: true
        }
      }
    });
    $(".fc_form").validate({
      rules: {
        "fitness_camp[session_start_date]": {
          required: true,
          date: true
        },
        "fitness_camp[session_end_date]": {
          required: true,
          date: true,
          greaterThan: "#fitness_camp_session_start_date"
        }
      }
    });
    $(".datepicker").datepicker({ dateFormat: 'D, dd M yy' });
    ///////////////////////////////////////////////////////////
    $('#start_datetimepicker').datetimepicker({
        dateFormat: 'D, dd M yy',
        onClose: function(dateText, inst) {
            var endDateTextBox = $('#end_datetimepicker');
            if (endDateTextBox.val() != '') {
                var testStartDate = new Date(dateText);
                var testEndDate = new Date(endDateTextBox.val());
                if (testStartDate > testEndDate)
                    endDateTextBox.val(dateText);
            }
            else {
                endDateTextBox.val(dateText);
            }
        },
        onSelect: function (selectedDateTime){
            var start = $(this).datetimepicker('getDate');
            $('#end_datetimepicker').datetimepicker('option', 'minDate', new Date(start.getTime()));
        }
    });
    $('#end_datetimepicker').datetimepicker({
        dateFormat: 'D, dd M yy',
        onClose: function(dateText, inst) {
            var startDateTextBox = $('#start_datetimepicker');
            if (startDateTextBox.val() != '') {
                var testStartDate = new Date(startDateTextBox.val());
                var testEndDate = new Date(dateText);
                if (testStartDate > testEndDate)
                    startDateTextBox.val(dateText);
            }
            else {
                startDateTextBox.val(dateText);
            }
        },
        onSelect: function (selectedDateTime){
            var end = $(this).datetimepicker('getDate');
            $('#example16_start').datetimepicker('option', 'maxDate', new Date(end.getTime()) );
        }
    });

    //////////////////////////////////////////////////////////
    $(".input_time").timePicker({ startTime: "5:00", endTime: "19:00", step: 60});
    $("#workout_fit_wit_workout_id").change(function () {
        var workout_id = $(this).val();
        $.getJSON('/backend/fit_wit_workouts/' + workout_id + '.json', function(data) {
            $("#workout_description").html("<b>Units:</b> " + data.score_method + "<br><b>Description:</b> " + data.description + "</div>");
            $(".score_input").attr("placeholder", data.placeholder_hint);
        })
        // need to set every workout field to the workout id
        $(".workout_fww_id").val(workout_id)
    })
    $("#record_workouts").click(function () {
        if ($("#fit_wit_workout_id").val() == 0) {
            alert("You need to select a Fit Wit Workout for these folks.");
            return false;
        }
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
        $(".del_button").click(function() {
            $('#multiple_date_select').datepicker('refresh');
        })
    }
});

jQuery.fn.delay = function(time, func) {
    return this.each(function() {
        setTimeout(func, time);
    });
};


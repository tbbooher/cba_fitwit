// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function goToGoogleMap($daddr)
{
    window.open("http://maps.google.com/maps?saddr=" + escape($("source_addy").value) + "&daddr=" + escape($daddr) + "&hl=en");
}

function change_status(click) {
    // click is set to false by default, true only if the user clicks . . .
    // we want it to be a custom workout by default
    var plus = "<span class=\"ui-icon ui-icon-plusthick\" style=\"padding-bottom: 0px;\"></span>";
    var minus = "<span class=\"ui-icon ui-icon-minusthick\" style=\"padding-bottom: 0px;\"></span>";
    cw = $("#adding_new_workout").attr('value') == 'false' ? false : true;
    if ((!click && cw) || (click && !cw)) {
        // Custom
        $("#custom_workout_custom_name").attr('class',"required");
        $("#custom_workout_fit_wit_workout_id").attr('class',"");
        $("#custom_section").show('highlight');
        $("li#fit_wit_workout_select").hide();
        $("li#fit_wit_workout_description").hide();
        //$("#custom_workout_fit_wit_workout_id").attr('disabled', 'disabled');
        //$("#fit_wit_workout_select label").attr('style', 'color:gray;');
        $("#adding_new_workout").attr('value', 'true');
        $("#custom_workout_button").html("I did a FitWit workout");
    } else {
        // we are doing a fitwit workout
        $("#custom_workout_custom_name").attr('class',"");
        $("#custom_workout_fit_wit_workout_id").attr('class',"required");
        $("#custom_section").hide();
        $("li#fit_wit_workout_select").show('highlight');
        $("#custom_workout_fit_wit_workout_id").removeAttr('disabled');
        $("#fit_wit_workout_select label").removeAttr('style');
        $("#adding_new_workout").attr('value', 'false');
        $("#custom_workout_button").html("No thanks, I did my own");
        $('li#fit_wit_workout_description').show();
    }
    return false;
}

// main document code
$(document).ready(function() {
    $(".registration_submit").click(function () {
        var ts_id = $(this).attr('id').replace("reg_", "");
        $.post('/registration/add_to_cart', {id: ts_id}, null, "script");
        return false;
    });
    // checkbox work
    $("div.checkbox input[type=checkbox]").click(function() {
        var my_title = $(this).attr('id').replace("user_", "#") + "_explanation";
        if ($(this).attr('checked')) {
            $(my_title).show('highlight', function() {
                $(my_title + " textarea").focus();
            });
        }
        else {
            $(my_title).hide('slow');
        }
    });
    //datepicker
    $(".inputdate").datepicker({ dateFormat: 'D, dd M yy' });
    // main admin page
    $("#tabs").tabs();
    // specific fit_wit_workout page
    $("#accordion").accordion();
    // add custom workout page
    $('li#fit_wit_workout_description').hide();
    $('#custom_workout_fit_wit_workout_id').change(function() {
        $('li#fit_wit_workout_description').show();
        fit_wit_workout_id = $('#custom_workout_fit_wit_workout_id').val();
        $.getJSON("/fit_wit_workouts/" + fit_wit_workout_id + ".json",
            function(json) {
                $('#the_description').html(json.description);
            });
    });
    //$("#custom_fit_wit_workout").hide();  // can't find it
    // custom workout forms
    change_status(false);
    $("#custom_workout_button").click(function() {
        change_status(true);
        return false;
    });
    //all hover and click logic for buttons -- general code
    $(".fg-button:not(.ui-state-disabled)")
            .hover(
            function() {
                $(this).addClass("ui-state-hover");
            },
            function() {
                $(this).removeClass("ui-state-hover");
            }
            )
            .mousedown(function() {
        // they want a FitWit Workout
        $(this).parents('.fg-buttonset-single:first').find(".fg-button.ui-state-active").removeClass("ui-state-active");
        if ($(this).is('.ui-state-active.fg-button-toggleable, .fg-buttonset-multi .ui-state-active')) {
            $(this).removeClass("ui-state-active");
        }
        else {
            $(this).addClass("ui-state-active");
        }
    })
            .mouseup(function() {
        if (! $(this).is('.fg-button-toggleable, .fg-buttonset-single .fg-button, .fg-buttonset-multi .fg-button')) {
            $(this).removeClass("ui-state-active");
        }
    });
});
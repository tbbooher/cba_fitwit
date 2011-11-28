$(document).ready(function() {
    $("#dialog-form").hide();
    $("#moving_image").hide();
    $(".fit_wit_workout").click(function () {
        $('#moving_image').fadeIn(4);
    });
    $(".bottom_date").click(function() {
        // set data parameter
        var my_date = $(this).attr('href').split('=')[1];
        $("#custom_workout_workout_date").attr('value', my_date);
        $("#dialog-form").dialog({
            autoOpen: false,
            show: 'blind',
            hide: 'explode',
            resizable: false,
            width: 900,
            modal: true,
            title: 'Add workout for ' + my_date
        });
        $("#dialog-form").dialog('open');
        return false;
    });
    $("#calendar a.activity").qtip({
        content: {
            text: false, //$(this).attr('title'),
            title: false
        },
        show: { effect: 'slide' },
        position: {
            adjust: {
                screen: true // Keep the tooltip on-screen at all times
            }
        },
        style: {
            width: { min: 200 },
            title: { 'font-size': 12, 'height': 20 } ,
            border: {
                width: 5,
                radius: 6,
                color: '#efefef'
            },
            tip: true
        }
    });
    $("#calendar div.date_button").qtip({
        content: {
            text: 'Click to add your own workout', //$(this).attr('title'),
            title: false
        },
        show: { effect: 'slide' },
        position: {
            adjust: {
                screen: true // Keep the tooltip on-screen at all times
            }
        },
        style: {
            width: { min: 200 },
            title: { 'font-size': 12, 'height': 20 } ,
            border: {
                width: 5,
                radius: 6,
                color: '#efefef'
            },
            tip: true
        }
    });
    $('#new_custom_workout').validate();
});
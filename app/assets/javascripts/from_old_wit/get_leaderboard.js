$( document ).ready (function() {
    $('div#the_fit_wit_workout_progress').hide();
    $('div#moving_image').hide(); // always hide moving image on load
//    $('#typedChart').gchart({series: [$.gchart.series([20, 50, 30])]});
    $('#fit_wit_workout_id').change( function() {
        $('div#the_fit_wit_workout_progress').hide();
        $('div#moving_image').fadeIn(100); // fadeIn(20);
        var fit_wit_workout_id = $(this).val();
        $.get("/my_fit_wit/leader_board/" + fit_wit_workout_id,
        {},
                function(html) {
                    $('#the_fit_wit_workout_progress').html(html);
                    $('div#moving_image').hide();
                    $('div#the_fit_wit_workout_progress').fadeIn(500);
                },
        'html'
        );
    });
});
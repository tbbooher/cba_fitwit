$( document ).ready (function() {
    $('div#the_exercise_progress').hide();
    $('div#moving_image').hide(); // always hide moving image on load
//    $('#typedChart').gchart({series: [$.gchart.series([20, 50, 30])]});
    $('#exercise_id').change( function() {
        $('div#the_exercise_progress').hide();
        $('div#moving_image').fadeIn(100); // fadeIn(20);
        var exercise_id = $(this).val();
        $.get("/my_fit_wit/leader_board/" + exercise_id,
        {},
                function(html) {
                    $('#the_exercise_progress').html(html);
                    $('div#moving_image').hide();
                    $('div#the_exercise_progress').fadeIn(500);
                });
    });
});
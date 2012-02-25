$(document).ready ->
  # general code
  $(".datepicker").datepicker dateFormat: "D, dd M yy"
  $('#new_custom_workout').validate()
  # fit wit measurements
  $("#other_measurements").hide()
  $("#other_selector").toggle (->
    $("#other_measurements").fadeIn 300
    $(this).text "Remove additional measurements"
  ), ->
    $(this).text "Add additional measurements"
    $("#other_measurements").hide "slow"

  $("#measurement_form").validate submitHandler: (form) ->
    form.submit ->
      $.post $(this).attr("action"), $(this).serialize(), null, "script"
      false

  # tracker code -- single fit_wit_workout_progress
  $("div#the_fit_wit_workout_progress").hide()
  $("div#moving_image").hide()
  $("#fit_wit_workout_id").change ->
    $("div#the_fit_wit_workout_progress").hide()
    $("div#moving_image").fadeIn 100
    fit_wit_workout_id = $(this).val()
    $.get "/my_fit_wit/leader_board/" + fit_wit_workout_id, {}, (html) ->
      $("#the_fit_wit_workout_progress").html html
      $("div#moving_image").hide()
      $("div#the_fit_wit_workout_progress").fadeIn 500

  # some code to hide and display the workout details
  $("li#fit_wit_workout_description").hide()
  # the following does not exist . . . we can get it ready
  $("#custom_workout_fit_wit_workout_id").change ->
    $("li#fit_wit_workout_description").show()
    fit_wit_workout_id = $("#custom_workout_exercise_id").val()
    $.get "fit_wit_workout_details/" + fit_wit_workout_id,
      id: fit_wit_workout_id
    , (html) ->
      $("#the_description").html html



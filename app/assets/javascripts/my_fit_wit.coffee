$(document).ready ->
  # general code
  $(".datepicker").datepicker dateFormat: 'D, dd M yy'
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
  # workout tracker code
  $("div#the_exercise_progress").hide()
  $("div#moving_image").hide()
  $("#exercise_id").change ->
    $("div#the_exercise_progress").hide()
    $("div#moving_image").fadeIn 100
    exercise_id = $(this).val()
    $.get "/my_fit_wit/leader_board/" + exercise_id, {}, (html) ->
      $("#the_exercise_progress").html html
      $("div#moving_image").hide()
      $("div#the_exercise_progress").fadeIn 500

  change_status = (click) ->
    plus = "<span class=\"ui-icon ui-icon-plusthick\" style=\"padding-bottom: 0px;\"></span>"
    minus = "<span class=\"ui-icon ui-icon-minusthick\" style=\"padding-bottom: 0px;\"></span>"
    cw = (if $("#adding_new_workout").attr("value") is "false" then false else true)
    if (not click and cw) or (click and not cw)
      $("#custom_workout_custom_name").attr "class", "required"
      $("#custom_workout_exercise_id").attr "class", ""
      $("#custom_section").show "highlight"
      $("li#exercise_select").hide()
      $("li#exercise_description").hide()
      $("#adding_new_workout").attr "value", "true"
      $("#custom_workout_button").html "I did a FitWit workout"
    else
      $("#custom_workout_custom_name").attr "class", ""
      $("#custom_workout_exercise_id").attr "class", "required"
      $("#custom_section").hide()
      $("li#exercise_select").show "highlight"
      $("#custom_workout_exercise_id").removeAttr "disabled"
      $("#exercise_select label").removeAttr "style"
      $("#adding_new_workout").attr "value", "false"
      $("#custom_workout_button").html "No thanks, I did my own"
      $("li#exercise_description").show()
    false

  $("li#exercise_description").hide()
  $("#custom_workout_exercise_id").change ->
    $("li#exercise_description").show()
    exercise_id = $("#custom_workout_exercise_id").val()
    $.get "exercise_details/" + exercise_id,
      id: exercise_id
    , (html) ->
      $("#the_description").html html

  change_status false
  $("#custom_workout_button").click ->
    change_status true
    false


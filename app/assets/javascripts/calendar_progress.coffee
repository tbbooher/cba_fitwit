$(document).ready ->
  $("#dialog-form").hide()
  $("#moving_image").hide()
  $(".fit_wit_workout").click ->
    $("#moving_image").fadeIn 4

  $(".bottom_date").click ->
    my_date = $(this).attr("href").split("=")[1]
    $("#custom_workout_workout_date").attr "value", my_date
    $("#dialog-form").dialog
      autoOpen: false
      show: "blind"
      hide: "explode"
      resizable: false
      width: 900
      modal: true
      title: "Add workout for " + my_date

    $("#dialog-form").dialog "open"
    false

  $("#calendar a.activity").qtip
    content:
      text: false
      title: false

    show:
      effect: "slide"

    position:
      adjust:
        screen: true

    style:
      width:
        min: 200

      title:
        "font-size": 12
        height: 20

      border:
        width: 5
        radius: 6
        color: "#efefef"

      tip: true

  $("#calendar div.date_button").qtip
    content:
      text: "Click to add your own workout"
      title: false

    show:
      effect: "slide"

    position:
      adjust:
        screen: true

    style:
      width:
        min: 200

      title:
        "font-size": 12
        height: 20

      border:
        width: 5
        radius: 6
        color: "#efefef"

      tip: true

  $("#new_custom_workout").validate()
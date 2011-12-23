$(document).ready ->
  $("#vet_status_changer").hide()
  $("#vet_status").click ->
    $("#vet_status_changer").dialog
      autoOpen: false
      show: "blind"
      hide: "explode"
      resizable: false
      width: 900
      modal: true
      title: "Change your FitWit history"

    $("#vet_status_changer").dialog "open"
    false
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

  $(".approval_field_yes_is_bad").change ->
    vital_div = $('#' + this.id + '_explanation')
    text_area = $('#' + this.id + '_explanation_ta')
    if ($(this).val() is "false")
      vital_div.hide()
      text_area.removeClass("required")
    else
      vital_div.show()
      text_area.addClass("required")

  $(".approval_field_yes_is_good").change ->
    vital_div = $('#' + this.id + '_explanation')
    text_area = $('#' + this.id + '_explanation_ta')
    if ($(this).val() is "true")
      vital_div.hide()
      text_area.removeClass("required")
    else
      vital_div.show()
      text_area.addClass("required")

  $(".med_checkbox").click ->
    $("#explanation_div_" + this.id).toggle()

  $("#consent_form").validate();
  $("#health_status").validate();
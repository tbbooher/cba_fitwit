$(document).ready ->
  $(".health_condition").click ->
    e = $(this).closest('.health_issue_parent').find(".explain_yourself")
    (if $(this).is(":checked") then e.show() else e.hide())

    # df = $(this).parent().parent().parent().parent().children().last().children().last().children().first()
    df = $(this).closest('.health_issue_parent').find(".destroy_field")
    if (df.val() is "1")
      df.val("0")
    else
      df.val("1")

  $("input[name='user[has_physician_approval]']").change ->
    if ($("input[name='user[has_physician_approval]']:checked").val() is "false")
      $("#explain_pa").show()
    else
      $("#explain_pa").hide()

  $("input[name='user[meds_affect_vital_signs]']").change ->
    e = $("#explain_ma")
    if ($("input[name='user[meds_affect_vital_signs]']:checked").val() is "true")
      e.show()
    else
      e.hide()

  $("#consent_form").validate()
  $("#health_status").validate()
  $("#update_personal_information_form").validate()
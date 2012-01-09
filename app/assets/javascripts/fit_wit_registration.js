// registration health consent
$("#health_history_update").hide();
// open any necessary windows
$("#health_approval_participation_approved_no").click(function () {
  $("#health_approval_participation_approved_explanation").show().focus().select();
});
$("#health_approval_participation_approved_yes").click(function () {
  $("#health_approval_participation_approved_explanation").hide('slow');
});
$("#health_approval_taking_medications_yes").click(function () {
  $("#health_approval_taking_medications_explanation").show().focus().select();
});
$("#health_approval_taking_medications_no").click(function () {
  $("#health_approval_taking_medications_explanation").hide('slow');
});
$(".health_history_link").click(function () {
  $("#health_history_update").dialog({
      autoOpen: false,
      show: 'blind',
      hide: 'explode',
      resizable: false,
      width: 900,
      modal: true,
      title: 'Your health history'
  });
  $("#health_history_update").dialog('open');
  return false;
});

window.onload = function() {
  $("estrogen").hide();
}
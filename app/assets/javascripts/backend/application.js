// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


//= require backend/jquery-ui.multidatespicker
//= require backend/jquery.timePicker.min

$(document).ready(function() {
  $(".input_time").timePicker({ startTime: "5:00", endTime: "19:00", step: 60});
  $('#multi-months').multiDatesPicker({
    numberOfMonths: 3
  });
});
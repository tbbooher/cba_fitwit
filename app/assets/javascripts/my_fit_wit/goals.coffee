$(document).ready ->
  $(".goal_complete").live "click", ->
    goal_id = $(this).attr("title")
    $.post "/my_fit_wit/update_goal",
      id: goal_id
    , null, "script"
    false

  $(".delete_goal").live "click", ->
    goal_id = $(this).attr("title")
    $.post "/my_fit_wit/delete_goal",
      id: goal_id
    , null, "script"
    false

  $("#new_goal").validate submitHandler: (form) ->
    form.submit ->
      $.post $(this).attr("action"), $(this).serialize(), null, "script"
      false
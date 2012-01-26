$(document).ready ->
  tig = $(".blog_calendar")
  i = 0
  while i < tig.length
    $.ajax
      url: "/calendar/events/" + tig[i].id
      success: (events)->
        $(".blog_calendar").datepicker
          beforeShowDay: (date) ->
            result = [ true, "", null ]
            matching = $.grep(events, (event) ->
              the_date = new Date(event.Date)
              the_date.valueOf() is date.valueOf()
            )
            result = [ true, "highlight", null ]  if matching.length
            result

          onSelect: (dateText) ->
            date = undefined
            selectedDate = new Date(dateText)
            i = 0
            event = null
            while i < events.length and not event
              date = new Date(events[i].Date)
              event = events[i]  if selectedDate.valueOf() is date.valueOf()
              i++
            $("#description_" + this.id).html(event.Title)  if event
      i++
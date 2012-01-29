$(document).ready ->
  if $(".blog_calendar").length > 0
    e = $(".blog_calendar")
    $.ajax
      url: "/calendar/events/" + e.attr('id')
      success: (events)->
        e.datepicker
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
            if event
              $("#describer_of_event").show()
              $("#event_title").html(event.Date)
              $("#description_" + this.id).html(event.Title)
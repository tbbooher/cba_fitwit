
$(document).ready ->
  events = []
  dp = $(".blog_calendar").datepicker
    beforeShowDay: (date) ->
      $.getJSON "/calendar/events/" + this.id, (data) ->
        events = data
      result = [ true, "", null ]
      matching = $.grep(events, (event) ->
        event.Date.valueOf() is date.valueOf()
      )
      result = [ true, "highlight", null ]  if matching.length
      result

    onSelect: (dateText) ->
      date = undefined
      selectedDate = new Date(dateText)
      i = 0
      event = null
      while i < events.length and not event
        date = events[i].Date
        event = events[i]  if selectedDate.valueOf() is date.valueOf()
        i++
      alert event.Title  if event
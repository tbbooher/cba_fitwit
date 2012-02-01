$(document).ready(function() {

    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    var location_id = window.location.pathname.split("/")[3];

    $('#fit_wit_calendar').fullCalendar({
        editable: false,
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'month',
        height: 500,
        slotMinutes: 60,
        loading: function(bool) {
            if (bool)
                $('#loading').show();
            else
                $('#loading').hide();
        },
        eventSources: [
            {
                url: '/calendar/all_events/',
                color: '#dfdfdf',
                textColor: 'black',
                ignoreTimezone: false
            }
        ],
        timeFormat: 'h:mmt',
        // http://arshaw.com/fullcalendar/docs/mouse/eventClick/
        eventClick: function(event, jsEvent, view) {
            if (event.id.length > 0 && event.id != 'blank') {
                $.getJSON('/calendar/display_event/' + event.id, function(data) {
                    $('#events').fadeIn();
                    $('#event_title').html(data.title);
                    $('#event_start').html(data.start);
                    $('#event_end').html(data.end);
                    $('#event_description').html(data.description);
                })
            }
            return false;
        }
    });
});
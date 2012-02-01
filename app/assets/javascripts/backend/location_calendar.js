$(document).ready(function() {

    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    var location_id = window.location.pathname.split("/")[3];

    $('#location_calendar').fullCalendar({
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

        // a future calendar might have many sources.
        eventSources: [
            {
                url: '/backend/locations/' + location_id + '/events',
                color: 'blue',
                textColor: 'white',
                ignoreTimezone: false
            },
            {
                url: '/calendar/all_camp_events/' + location_id,
                color: 'green',
                textColor: 'white',
                ignoreTimezone: false
            }
        ],

        timeFormat: 'h:mmt',
        dragOpacity: "0.5",
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
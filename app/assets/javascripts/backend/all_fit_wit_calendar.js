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

        // a future calendar might have many sources.
        eventSources: [
            {
                url: '/calendar/all_events/',
                color: '#dfdfdf',
                textColor: 'black',
                ignoreTimezone: false
            }
        ],

        timeFormat: 'h:mmt',
        dragOpacity: "0.5",
        // http://arshaw.com/fullcalendar/docs/mouse/eventClick/
        eventClick: function(event, jsEvent, view) {
            alert('test');
        }
    });
});
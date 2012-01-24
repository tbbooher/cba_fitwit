//= require backend/jquery-1.5.2.min
//= require jquery_ujs
//= require backend/jquery-ui-1.8.11.custom.min
//= require backend/jquery.rest
//= require backend/fullcalendar
//= require backend/calendar

// should we add gcal ?

$(function (){
    $(".datepicker").datepicker({ dateFormat: 'D, dd M yy' });
    $(".datetimepicker").datetimepicker({ dateFormat: 'D, dd M yy' });
});

jQuery.fn.delay = function(time,func){
    return this.each(function(){
        setTimeout(func,time);
    });
};


//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.rest
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


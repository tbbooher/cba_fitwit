//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(function (){
    $(".datepicker").datepicker({ dateFormat: 'D, dd M yy' });
    $(".datetimepicker").datetimepicker({ dateFormat: 'D, dd M yy' });
});

jQuery.fn.delay = function(time,func){
    return this.each(function(){
        setTimeout(func,time);
    });
};


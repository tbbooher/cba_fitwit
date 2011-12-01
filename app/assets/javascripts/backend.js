//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(function (){
    $(".datepicker").datepicker();
});

jQuery.fn.delay = function(time,func){
    return this.each(function(){
        setTimeout(func,time);
    });
};


// -*- encoding : utf-8 -*-
//
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// This is just temporary so I don't have to pull from inteweb
// require plusone

// require at_top/l10n
//= require backend/jquery-1.5.2.min
// ^^ this is needed for fullcalendar only

//= require at_top/preloader
// require at_top/hoverIntent
// require at_top/superfish
// require at_top/scrollable.min
// require at_top/jquery.prettyphoto
// require at_top/prettyphoto_init
// require at_top/comment-reply
//= require at_bottom/cold_custom

//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.validate.min
//= require jsort_sortable
//= require progress_upload_field
//= require autocomplete
//= require jquery.Jcrop

//= require cba
//= require cba_string
//= require flashes
//= require jquery.tokeninput
//= require maps
//= require page_component_sortable
//= require page
//= require postings
//= require search
//= require side_tab
//= require sprintf
//= require registration

//= require textile
//= require user
//= require user_notifications
//= require user_crop_avatar

//= require location_page

//= require flickr/jQuery.flickr

//= require twitter/jquery.tweet

// for calendars

//= require backend/jquery.rest
//= require backend/fullcalendar
//= require backend/all_fit_wit_calendar
//= require backend/location_calendar
//= require blog_side_calendar
//= require qtip/jquery.qtip
//= require calendar_progress
//= require my_fit_wit

$(document).ready(function() {
  $("#sign_up_form").validate();
})
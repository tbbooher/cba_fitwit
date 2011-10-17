jQuery(window).load(function(){
	jQuery('.share_buttons').css('left', -jQuery('.share_buttons').width());
	jQuery('.share_button').toggle(
		function() {
			var $lefty = jQuery(this).next('.share_buttons');
			$lefty.animate({
				left: jQuery(this).width()
			});
		},
		function() {
			var $lefty = jQuery(this).next('.share_buttons');
			$lefty.animate({
				left: -$lefty.outerWidth()
			});
		}
	);
});
jQuery(document).ready(function(){
	jQuery(".toggle_title").toggle(
		function() {
			jQuery(this).addClass('toggle_active');
			jQuery(this).next('.toggle_content').slideDown("fast");
		},
		function() {
			jQuery(this).removeClass('toggle_active');
			jQuery(this).next('.toggle_content').slideUp("fast");
		}
	);
	jQuery(".accordion_title").click(
		function() {
			jQuery(this).siblings('.accordion_content').slideUp("fast");
			jQuery(this).siblings('.accordion_title').removeClass('accordion_active');
			if(jQuery(this).hasClass('accordion_active')) {
				jQuery(this).removeClass('accordion_active');
			} else {
				jQuery(this).addClass('accordion_active');
				jQuery(this).next('.accordion_content').slideDown("fast");
			}
		}
	);
	jQuery('a.tab').each(function(index) {
		jQuery(this).attr('id', 'tab' + index);
		jQuery('div.tab_content').eq(index).attr('id', 'tab' + index);
		if(jQuery(this).parent('li').hasClass('current')) {
			jQuery('div.tab_content').eq(index).css('left', '0');
			jQuery('div.tab_content').eq(index).css('position', 'relative');
			jQuery('div.tab_content').eq(index).show();
		}
	});
	jQuery("a.tab").click(
		function(event) {
			event.preventDefault();
			jQuery(this).parents('ul').children('li.current').removeClass('current');
			jQuery(this).parent('li').addClass('current');
			jQuery(this).parents('ul').children('li').each(function() { jQuery('div#' + jQuery(this).children('a').attr('id')).hide(); });
			jQuery('div#' + jQuery(this).attr('id')).css('left', '0');
			jQuery('div#' + jQuery(this).attr('id')).css('position', 'relative');
			jQuery('div#' + jQuery(this).attr('id')).show();
		}
	);
});

jQuery(function() {
	jQuery('ul.sf-menu').superfish({ delay: 300, animation: { height:'show' }, speed: 'normal' });
});
jQuery(document).ready(function() {
	jQuery("#aslider").css('overflow', 'hidden');
	jQuery("#aslider").krioImageLoader({ onStart: function() {
		jQuery(this).anythingSlider({
			hashTags: false,
			autoPlay: true,
			autoPlayLocked: true,
			resumeDelay: 5000,
			height: slideParams['height'],
			easing: slideParams['effect'],
			animationTime: slideParams['animationTime'],
			delay: slideParams['delay'],
			buildArrows: slideParams['buildArrows'],
			toggleArrows: slideParams['toggleArrows'],
			buildNavigation: slideParams['buildNavigation'],
			toggleControls: slideParams['toggleControls'],
			enableKeyboard: slideParams['enableKeyboard'],
			pauseOnHover: slideParams['pauseOnHover'],
			stopAtEnd: slideParams['stopAtEnd'],
			startText: slideParams['startText'],
			stopText: slideParams['stopText']
		});
	}});
});

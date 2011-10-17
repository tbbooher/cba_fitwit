jQuery(document).ready(function() {
	jQuery("#slider").krioImageLoader({ onStart: function(){
			jQuery(this).nivoSlider({
				effect:slideParams['effect'],
				slices:slideParams['slices'],
				startSlide:0,
				animSpeed:slideParams['animSpeed'],
				pauseTime:slideParams['pauseTime'],
				directionNav:slideParams['directionNav'],
				directionNavHide:slideParams['directionNavHide'],
				controlNav:slideParams['controlNav'],
				controlNavThumbs:false,
				keyboardNav:slideParams['keyboardNav'],
				pauseOnHover:slideParams['pauseOnHover'],
				captionOpacity:slideParams['captionOpacity'],
				height:slideParams['height']+'px',
				lastSlide: function() {
					if(slideParams['stopAtEnd']){
						slider.data('nivoSlider').stop();
					}
				}
			});
	}});
	jQuery('.nivo-directionNav').css('top', (slideParams['height']/2)-15);
});

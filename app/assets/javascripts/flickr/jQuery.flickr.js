/* Flickr Gallery script 
* powered by jQuery (http://www.jquery.com)

* written by Richard Shepherd (http://richardshepherd.com)

* for more info visit 
* http://www.richardshepherd.com/how-to-use-jquery-with-a-json-flickr-feed-to-display-photos/ 

 22926012@N03 */
function getFlickr(userid, target, numberToDisplay) {

    var url = "http://api.flickr.com/services/feeds/photos_public.gne?id=" + userid + "&lang=en-us&format=json&jsoncallback=?";

    $.getJSON(url, displayImages);

    function displayImages(data) {
        var htmlString = "";

        var ctr = 0;
        $.each(data.items, function(i, item) {

            if (ctr < numberToDisplay) {
                var sourceSquare = 
                    (item.media.m).replace("_m.jpg", "_s.jpg");
                var sourceOrig = 
                    (item.media.m).replace("_m.jpg", ".jpg");

				htmlString += '<div style="float:right; margin-bottom: 10px;">';
                htmlString += '<a href="' + sourceOrig + '" class="preview border-img" title="' + item.title + '" target="_blank" style="opacity: 1;">';
                htmlString += '<img title="' + item.title + '" src="' + sourceSquare + '" ';
                htmlString += 'alt="' + item.title + '" style="opacity: 1;" class="flickrResize" />';
                htmlString += '</a>';
				htmlString += '</div>';
                ctr = ctr + 1
            }
        });

        $('#' + target).append(htmlString);

        //update image preview so we get 
        //the nice popup mouseovers on the images
        //Note: this uses the Image Preview Script, 
        //if not using it remove the below line.



//        imagePreview();            
    }
}

/* Image preview script 
 * powered by jQuery (http://www.jquery.com)

 * written by Alen Grakalic (http://cssglobe.com)

 * for more info visit 
 * http://cssglobe.com/post/1695/easiest-tooltip-and-image-preview-using-jquery */
 
this.imagePreview = function(){    
    /* CONFIG */
    xOffset = -20;
    yOffset = -100;
        
    // these 2 variable determine popup's distance from the cursor
    // you might want to adjust to get the right result
        
    /* END CONFIG */
    $("a.preview").hover(function(e){
        this.t = this.title;
        this.title = "";    
        var c = (this.t != "") ? "<br/>" + this.t : "";
        $("body").append("<p id='preview'><img src='"+ 
            this.href +"' alt='Image preview' />"+ c +"</p>");                                 
        $("#preview")
            .css("top",(e.pageY - xOffset) + "px")
            .css("left",(e.pageX + yOffset) + "px")
            .fadeIn("fast");                        
    },
    function(){
        this.title = this.t;    
        $("#preview").remove();
    });    
    $("a.preview").mousemove(function(e){
        $("#preview")
            .css("top",(e.pageY - xOffset) + "px")
            .css("left",(e.pageX + yOffset) + "px");
    });            
};


// starting the script on page load
$(document).ready(function(){
    imagePreview();
});
module BaseHelper

  def video(camper)
    png,ogg,mp4 = ['png','ogg', 'mp4'].map {|x| "https://s3.amazonaws.com/FitWit/movies/#{camper}.#{x}" }
    flash_vars = "config={&quot;playlist&quot;:[&quot;http://r3b.co/work/fitwit/assets/stories/brandi.png&quot;, {&quot;url&quot;: &quot;http://r3b.co/work/fitwit/assets/stories/brandi.mp4&quot;,&quot;autoPlay&quot;:false,&quot;autoBuffering&quot;:true}]}"
    content_tag :div, class: "full_page" do
      content_tag :video, width: 640, height: 480, poster: png, controls: "controls" do
        content_tag :object do
          content_tag(:source, nil, src: mp4, type: "video/mp4") +
          content_tag(:source, nil, src: ogg, type: "video/ogg") +
          content_tag(:object, nil, id: "flash_fallback_1", class: 'vjs-flash-fallback', width: '640', height: '480', type: 'application/x-shockwave-flash', data: 'http://releases.flowplayer.org/swf/flowplayer-3.2.1.swf') +
          content_tag(:param, nil, name: "movie", value: "http://releases.flowplayer.org/swf/flowplayer-3.2.1.swf") +
          content_tag(:param, nil, name: "allowfullscreen", value: "true") +
          content_tag(:param, nil, name: "flashvars", value: flash_vars) +
          content_tag(:img, nil, src: png, width: 640, height: 480, alt: "poster image", title: 'No video playback capabilities.')
        end
      end
    end
  end

end
#!/Users/laurelbooher/.rvm/rubies/ruby-1.9.2-p290/bin/ruby 
data = <<LINES
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/galleria.min.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/galleria.classic.min.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/flowplayer.min.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/jquery.nivo.slider.pack.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/cold_custom.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/themes/cold/js/nivo_slider_init.js?ver=3.2.1'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/plugins/contact-form-7/jquery.form.js?ver=2.52'></script>
<script type='text/javascript' src='http://e404themes.com/cold/wp-content/plugins/contact-form-7/scripts.js?ver=2.4.4'></script>
LINES

data.split("\n").map{|d| d.match(/\'http.*\w+\.js\?.*?\'/)}.each do |m|
  if m
    url = m[0]
    puts url
    system("wget #{url}")
    url =~ /\/([\w\.]+\.js)(.*)?'/
    puts "trying: mv #{$1}#{$2} #{$1}"
    system("mv #{$1}#{$2} #{$1}")
  end
  
end


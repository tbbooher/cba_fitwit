$(document).ready ->
  if $(".location_map").length > 0
    tig = $(".location_map")
    i = 0
    console.log tig.length
    while i < tig.length
      the_id = tig[i].id
      l = $("#" + the_id)
      l.html('<img src="/images/spinner.gif" alt="Loading ...">')
      lat = l.data('lat')
      lng = l.data('lng')
      loadLocationMap(the_id,parseFloat(lng),parseFloat(lat))
      i++

loadLocationMap = (the_id, lng,lat) ->
  latlng = new google.maps.LatLng(lat,lng)
  myOptions = {
    zoom: 13,
    center: latlng,
    width: 300,
    height: 180,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById(the_id),myOptions)
  $('#' + the_id).height("180px").width("300px")
  marker = {
    position: latlng,
    map: map
  }
  locationMarker = new google.maps.Marker(marker)

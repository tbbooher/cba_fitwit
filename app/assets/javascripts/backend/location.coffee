$(document).ready ->
  if $("#location-map")
    $("#location-map").html('<img src="/images/spinner.gif" alt="Loading ...">')
    loadUserMap(parseFloat(33.739562),parseFloat(-84.361428))

loadUserMap = (lng,lat) ->
  latlng = new google.maps.LatLng(lng,lat)
  myOptions = {
    zoom: 13,
    center: latlng,
    width: 500,
    height: 300,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("location-map"),myOptions)
  $('#location-map').height("300px").width("500px")
  marker = {
    position: latlng,
    map: map
  }
  userMarker = new google.maps.Marker(marker)
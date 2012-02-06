$(document).ready ->
  if $("#users-gis_location-map")
    $("#users-gis_location-map").html('<img src="/images/spinner.gif" alt="Loading ..." style="box-shadow: none">')
    lnglat = $('#user_gis_location_token').html()
    if lnglat
      lng = lnglat.split(",")[0]
      lat = lnglat.split(",")[1]
      loadUserMap(parseFloat(lng),parseFloat(lat))
           
loadUserMap = (lng,lat) ->
  latlng = new google.maps.LatLng(lng,lat)
  myOptions = {
    zoom: 8,
    center: latlng,
    width: 300,
    height: 300,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("users-gis_location-map"),myOptions)
  $('#users-gis_location-map').height("300px").width("300px")
  marker = {
    position: latlng,
    map: map
  }
  userMarker = new google.maps.Marker(marker)  

this.loadGISLocation = (target,lnglat) ->
  lng = lnglat.split(",")[0]
  lat = lnglat.split(",")[1]
  userPosition = new google.maps.LatLng(parseFloat(lng),parseFloat(lat))
  myOptions = {
    zoom: 4,
    center: userPosition,
    width: 150,
    height: 150,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById(target),myOptions)
  $('#'+target).height("150px").width("150px")
  marker = {
    position: userPosition,
    map: map
  }
  userMarker = new google.maps.Marker(marker)

jQuery ->
  $('#address').keyup ->
    searchLocation()
      
# Update Map when searching for address or place
geocoder = null
map = null
$(document).ready ->
  if $('#gis_location-preview').html()
    geocoder = new google.maps.Geocoder();
    pos = $("#user_gis_location_token").val()
    unless pos == ""
      lat = parseFloat(pos.split(",")[0])
      lng = parseFloat(pos.split(",")[1])
      initial_zoom = 10
    else
      lat = 0.0
      lng = 0.0
      initial_zoom = 0
    userPosition = new google.maps.LatLng(lat,lng)
    myOptions = {
      zoom: initial_zoom,
      center: userPosition
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById("gis_location-preview"), myOptions)
    $("#gis_location-preview").height(200).width(200)
    unless pos == ""
      marker = new google.maps.Marker({
          map: map,
          position: userPosition
      })
  
searchLocation = ->
  search_term = $('#address').val()
  if search_term.length < 3
    # don't start searching if term is short
  else
    $('#user_gis_location_token').val(search_term)
    results = geocoder.geocode { address: search_term }, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        if results.length > 0
          map.setCenter(results[0].geometry.location)
          _z = 16 - results.length
          _z = 0 if _z < 0
          map.setZoom( _z )
          marker = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location
          })
          $('#user_gis_location_token').val(results[0].geometry.location)

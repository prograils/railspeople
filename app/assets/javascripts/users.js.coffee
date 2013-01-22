# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.map
jQuery ->
  #user/show
  init = ->
    map_options =
      zoom: $("#user_zoom").data('url')
      center: new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      mapTypeId: google.maps.MapTypeId.ROADMAP

    newMap = new google.maps.Map(document.getElementById("user_map"), map_options)

  placeNormalMarker = (latLng, map) ->
    marker = new google.maps.Marker(
      position: latLng
      map: map
      draggable: false
    )

  placeNearMarkers = (map) ->
    $.ajax
      url: "/near_coordinates"
      type: "GET"
      dataType: "json"
      data: "id=" + $("#user_id").data('url')
      success: (outputformserver) ->
        $.each outputformserver, (first, pair) ->
          latLng = new google.maps.LatLng(pair[0], pair[1])
          marker = new google.maps.Marker(
            position: latLng
            map: map
            draggable: false
          ) 

  #registration/new
  # Update form attributes with given coordinates
  updateFormLocation = (latLng, map) ->
    $("#user_latitude").val latLng.lat()
    $("#user_longitude").val latLng.lng()
    $("#user_zoom").val map.getZoom()
  
  # Add a marker with an open infowindow
  placeMarker = (latLng, map) ->
    marker = new google.maps.Marker(
      position: latLng
      map: map
      draggable: true
    )
    markersArray.push marker
    # Set and open infowindow
    infowindow = new google.maps.InfoWindow(content: "<div class=\"popup\"><h2>Awesome!</h2><p>Drag me and adjust the zoom level.</p>")
    infowindow.open map, marker
        
    # Listen to drag & drop
    google.maps.event.addListener marker, "dragend", ->
      updateFormLocation @getPosition()

  # Removes the overlays from the map
  clearOverlays = ->
    if markersArray
      i = 0
      while i < markersArray.length
        markersArray[i].setMap null
        i++
    markersArray.length = 0

  $(document).ready ->
    window.markersArray = []
    if document.getElementById("user_map")
      newMap = init()
      $('#user_map').addClass('gmaps4rails_map');
      $('#user_map').addClass('map_container');
      $('#user_map').addClass('google-maps');
      userMarker = new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      placeNormalMarker(userMarker, newMap)
      google.maps.event.addListener newMap, "click", (event) ->
        $('#near_people').removeClass('hidden')
        $('#near_people').addClass('visible')
        placeNearMarkers(newMap)

    if document.getElementById("registration_map")
      #gain acces to country coordinates after select
      window.map
      $("#user_country_id").change ->
        $.ajax
          url: "/countries_selection"
          type: "GET"
          dataType: "json"
          data: "id=" + $("#user_country_id").val()
          complete: ->

          success: (data, textStatus, xhr) ->
            
            # On click, clear markers, place a new one, update coordinates in the form
            # map.callback = function() {
            #   google.maps.event.addListener(map, 'click', function(event) {
            #     clearOverlays();
            #     placeMarker(event.latLng);
            #     updateFormLocation(event.latLng);
            #   });
            # };

            $("#registration_map").addClass "gmaps4rails_map"
            $("#registration_map").addClass "map_container"
            $('#registration_map').addClass('google-maps');
            map_options =
              zoom: 5
              center: new google.maps.LatLng(data.country.lat, data.country.lng)
              mapTypeId: google.maps.MapTypeId.ROADMAP

            map = new google.maps.Map(document.getElementById("registration_map"), map_options)
            google.maps.event.addListener map, "click", (event) ->
              clearOverlays()
              placeMarker event.latLng, map
              updateFormLocation event.latLng, map



# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.map
jQuery ->
  init = ->
    map_options =
      zoom: $("#user_zoom").data('url')
      center: new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      mapTypeId: google.maps.MapTypeId.ROADMAP

    newMap = new google.maps.Map(document.getElementById("user_map"), map_options)

  placeMarker = (latLng, map) ->
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

  $(document).ready ->
    if document.getElementById("user_map")
      window.markersArray = []
      newMap = init()
      $('#user_map').addClass('gmaps4rails_map');
      $('#user_map').addClass('map_container');
      userMarker = new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      placeMarker(userMarker, newMap)
      google.maps.event.addListener newMap, "click", (event) ->
        $('#near_people').removeClass('hidden')
        $('#near_people').addClass('visible')
        placeNearMarkers(newMap)

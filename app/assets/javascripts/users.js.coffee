# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sections = $("form#new_user").find('#socials h4, #skills h4, #work h4, #privacy h4, #avatar h4')
sections.click ->
  $(this).parent().find('.content').toggle();

sections.click()

window.map
jQuery ->
  #user/show
  init = (id, lat, lng, zoom) ->
    map_options =
      zoom: zoom
      center: new google.maps.LatLng(lat, lng)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    newMap = new google.maps.Map(document.getElementById(id), map_options)

  placeNormalMarker = (latLng, map, drag) ->
    marker = new google.maps.Marker(
      position: latLng
      map: map
      draggable: drag
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
          # infoWindow = new google.maps.InfoWindow()
          # google.maps.event.addListener marker, "click", ->
          #   markerContent = "bla"
          #   infoWindow.setContent markerContent
          #   infoWindow.open map, marker

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
      newMap = init("user_map", $("#user_lat").data('url'), $("#user_lng").data('url'), $("#user_zoom").data('url'))
      $('#user_map').addClass('gmaps4rails_map');
      $('#user_map').addClass('map_container');
      $('#user_map').addClass('google-maps');
      userMarker = new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      placeNormalMarker(userMarker, newMap, false)
      placeNearMarkers(newMap)
      # google.maps.event.addListener newMap, "click", (event) ->
      #   $('#near_people').removeClass('hidden')
      #   $('#near_people').addClass('visible')
      #   $('#near_information').addClass('hidden')
      #   google.maps.event.clearListeners(newMap, "click")

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
            map = init("registration_map", data.country.lat, data.country.lng, 5)
            google.maps.event.addListener map, "click", (event) ->
              clearOverlays()
              placeMarker event.latLng, map
              updateFormLocation event.latLng, map
    if document.getElementById("edit_map")
      window.markersArray = []
      window.map
      $("#edit_map").addClass "gmaps4rails_map"
      $("#edit_map").addClass "map_container"
      $('#edit_map').addClass('google-maps');
      editMap = init("edit_map", $("#user_lat").data('url'), $("#user_lng").data('url'), $("#user_zoom").data('url'))
      latLng = new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
      marker = new google.maps.Marker(
        position: latLng
        map: editMap
        draggable: true
      )
      markersArray.push marker
      google.maps.event.addListener marker, "dragend", (event) ->
        $("#user_latitude").val event.latLng.lat()
        $("#user_longitude").val event.latLng.lng()
      google.maps.event.addListener editMap, "zoom_changed", (event) ->
        $("#new_zoom").val editMap.getZoom()



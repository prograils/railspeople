# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sections = $("form#new_user").find('#socials h4, #skills h4, #work h4, #privacy h4, #avatar h4')
sections.click ->
  $(this).parent().find('.content').toggle();

sections.click()

setCountryAsNull = (list_id) ->
  user_country_list = $("#" + list_id)
  user_country_list.prepend "<option value='' selected='selected'></option>"

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

  getGithubRepos = () ->
    $.ajax
      url: "/user_github_repos"
      type: "GET"
      dataType: "json"
      data: "login=" + $("#github_repos").data('login')
      success: (outputformserver) ->
        $.each outputformserver, (index, data) ->
          link = $("<a>",
            text: data.name
            title: data.description
            href: data.url
            target: 'blank'
          )
          container = $("<div>",
            class: 'repo_item'
          )
          link.appendTo container
          container.appendTo "#github_repos"
          link.fadeIn index*200

  # Update form attributes with given datas
  updateFormZoom = (map) ->
    $("#user_zoom").attr 'value', map.getZoom()

  updateFormPos = (latLng) ->
    $("#user_latitude").attr 'value', latLng.lat()
    $("#user_longitude").attr 'value',latLng.lng()

  updateFormZoomAndPos = (map, latLng) ->
    updateFormZoom(map)
    updateFormPos(latLng)

  # Add a marker with an open infowindow
  placeMarker = (latLng, map) ->
    marker = new google.maps.Marker(
      position: latLng
      map: map
      draggable: true
    )
    # Set and open infowindow
    infowindow = new google.maps.InfoWindow(content: "<div class=\"popup\"><h2>Awesome!</h2><p>Drag me and adjust the zoom level.</p>")
    infowindow.open map, marker

    # Listen to drag & drop
    google.maps.event.addListener marker, "dragend", ->
      updateFormZoom map

  # Removes the overlays from the map
  clearOverlays = ->
    if markersArray
      i = 0
      while i < markersArray.length
        markersArray[i].setMap null
        i++
    markersArray.length = 0

  addClass = (map_container) ->
    map_container.addClass "gmaps4rails_map"
    map_container.addClass "map_container"
    map_container.addClass('google-maps')

  addListeners = (map, marker) ->
    google.maps.event.addListener map, "click", (event) ->
        marker.setPosition(event.latLng)
        updateFormZoomAndPos map, event.latLng

    google.maps.event.addListener map, "idle", (event)->
      updateFormZoomAndPos map, marker.getPosition()

    google.maps.event.addListener marker, "dragend", (event) ->
      updateFormPos marker.getPosition()

  window.markersArray = []
  #users/id
  if document.getElementById("user_map")
    newMap = init("user_map", $("#user_lat").data('url'), $("#user_lng").data('url'), $("#user_zoom").data('url') || 5)

    addClass($('#user_map'))
    userMarker = new google.maps.LatLng($("#user_lat").data('url'), $("#user_lng").data('url'))
    placeNormalMarker(userMarker, newMap, false)
    placeNearMarkers(newMap)
    # google.maps.event.addListener newMap, "click", (event) ->
    #   $('#near_people').removeClass('hidden')
    #   $('#near_people').addClass('visible')
    #   $('#near_information').addClass('hidden')
    #   google.maps.event.clearListeners(newMap, "click")

  if document.getElementById("github_repos")
    getGithubRepos()

  #registration/new
  if document.getElementById("registration_map")
    window.map

    editMap = new Object
    latLng = new Object
    marker = new google.maps.Marker(
      position: null
      map: null
      draggable: true
    )

    # when listItem selected
    $("#user_country_id").change ->
      $.ajax
        url: "/countries_selection"
        type: "GET"
        dataType: "json"
        data: "id=" + $("#user_country_id").val()
        complete: ->
        success: (data, textStatus, xhr) ->
          addClass($("#registration_map"))
          latLng = new google.maps.LatLng(data.country.lat, data.country.lng)
          regMap = init("registration_map", data.country.lat, data.country.lng, 5)
          marker.setMap(regMap)
          marker.setPosition(latLng)

          addListeners(regMap, marker)

  #registration/edit
  if document.getElementById("edit_map")
    markersArray = []
    window.map

    user_latitude = $("#user_latitude").val()
    user_longitude = $("#user_longitude").val()
    user_zoom =  parseInt($("#user_zoom").val(), 10)
    editMap = new Object
    latLng = new Object
    marker = new google.maps.Marker(
      position: null
      map: null
      draggable: true
    )
    user_country_list = $("#user_country_id")

    # when register with oauth, these form fields and user_zoom are empty
    if user_latitude != "" && user_longitude != ""
      addClass($("#edit_map"))
      editMap = init("edit_map", user_latitude, user_longitude, user_zoom)
      latLng = new google.maps.LatLng(user_latitude, user_longitude)
      marker.setMap(editMap)
      marker.setPosition(latLng)

      addListeners(editMap, marker)
    else
      # set country_id as null
      # setCountryAsNull("user_country_id")
      # $("#sections_container").find("section#map").insertBefore("section#user")

    # when listItem selected
    user_country_list.change ->
      $.ajax
        url: "/countries_selection"
        type: "GET"
        dataType: "json"
        data: "id=" + user_country_list.val()
        success: (data, textStatus, xhr) ->
          addClass($("#edit_map"))
          latLng = new google.maps.LatLng(data.lat, data.lng)
          editMap = init("edit_map", data.lat, data.lng, 5)
          marker.setMap(editMap)
          marker.setPosition(latLng)

          addListeners(editMap, marker)


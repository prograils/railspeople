initialize ->
  mapOptions =
    center: x
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoom: 6

  map = new google.maps.Map(document.getElementById("users_map"), mapOptions)
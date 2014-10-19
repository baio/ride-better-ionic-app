app.factory "geoLocator", ($q) ->

  getPosition: ->

    deferred = $q.defer()

    geolocationSuccess = (position) ->
      deferred.resolve  lat : position.coords.latitude, lon : position.coords.longitude

    geolocationError = (err) ->
      console.log ">>>geo.coffee:11", err

    geolocationOptions = enableHighAccuracy : true, timeout : 1000 * 60 * 60, maximumAge : 1000 * 60 * 15
    navigator.geolocation.getCurrentPosition geolocationSuccess, geolocationError, geolocationOptions

    deferred.promise
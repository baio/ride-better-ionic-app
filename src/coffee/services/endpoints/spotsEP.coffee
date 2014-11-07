app.factory "spotsEP", ($q, $resource, webApiConfig, mapper) ->

  resource = $resource(webApiConfig.url + "spots")

  inProgress = false

  get : (term, geo) ->

    $http.get('/someUrl').
    term = undefined if !term
    console.log "spot::get", term, geo

    defer = $q.defer()

    if inProgress
      defer.reject(message : "In Progress")
    else
      inProgress = true
      resource.query
        term : term
        geo : geo
        ((res) ->
          inProgress = false
          defer.resolve(mapper.mapSpots res)
        ),
        ((response) ->
          inProgress = false
          defer.reject(response)
        )

    defer.promise

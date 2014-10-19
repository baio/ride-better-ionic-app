app.factory "forecast", ($q, $resource, webApiConfig, mapper, cache) ->

  getInstantReportsCache : (spot) ->
    cache.get "instant-reports." + spot

  getInstantReportCache : (spot) ->
    cache.get "instant-report." + spot

  getForecastCache : (spot) ->
    cache.get "forecast." + spot

  getInstantReport : (spot) ->
    @getInstantReports(spot).then (res) ->
      cache.put "instant-report." + spot, res[0], "eod"
      res[0]

  getInstantReports : (spot) ->

    resource = $resource(webApiConfig.url + "instant-report/:spot", {code: "@spot"})
    defer = $q.defer()

    resource.query
      spot : spot
      ((res) ->
        res = mapper.mapInstantReports res
        cache.put "instant-reports." + spot, res, "eod"
        defer.resolve(res)
      ),
      ((response) ->
        defer.reject(response)
      )

    defer.promise

  getForecast : (spot) ->
    resource = $resource(webApiConfig.url + "forecast/:spot", {code: "@spot"})
    defer = $q.defer()

    resource.get
      spot : spot
      ((res) ->
        res = mapper.mapForecast res
        cache.put "forecast." + spot, res, "eod"
        defer.resolve(res)
      ),
      ((response) ->
        defer.reject(response)
      )

    defer.promise


app.factory "mapper", (prettifyer, culture) ->

  mapInstantReports: (reports) ->
    reports.map (m) =>
      spot : m.spot
      rating : @mapReportForecast m.forecast[0]
      nextRating : if m.forecast.length then @mapReportForecast m.forecast[1]
      report : @mapReports m.reports

  mapForecast: (forecast) ->
    exactDT = moment.utc(forecast.dateRange.exact)
    forecast.units =
      speed : culture.getSpeedUnits()
      height : culture.getHeightUnits()
      temperature : culture.getTempUnits()
    for ct, i in forecast.conditions
      ct.weather.temperature = culture.getTemp ct.weather.temperature
      ct.swell.height = culture.getHeight ct.swell.height
      ct.wind.speed = culture.getSpeed ct.wind.speed
      ct.wind.gusts = culture.getSpeed ct.wind.gusts
      dt = moment.utc(ct.dateTime)
      ct.time = dt.format("HH:SS")
      ct.rating.stars = prettifyer.getStars ct.rating.solid, ct.rating.faded
      if dt <= exactDT < moment.utc(forecast.conditions[i + 1].dateTime)
        ct.isCurrent = true
      else
        ct.isCurrent = false
    forecast

  mapReportForecast: (forecast) ->
    stars : prettifyer.getStars forecast.rating.solid, forecast.rating.faded
    time : moment(forecast.dt).format("HH:mm")

  mapReports: (reports) ->
    if reports.length
      messages : reports.map (m) -> code : m.code
      time : moment(reports[0].dt).format("HH:mm")
    else
      messages : []
      time : null

  mapSpots: (spots) ->
    spots.map (r) ->
      r.code = r.id
      r.units = dist : culture.getDistUnits()
      parts = [r.city, r.region, r.country].filter((f) -> f)
      r.descr = parts.join(", ")
      r.dist = culture.getDist(r.dist) if r.dist
      r

  mapUser: (user) ->
    res = profile : user.profile
    if user.data?.surf_better
      res.settings = user.data.surf_better
    res
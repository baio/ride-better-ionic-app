app.factory "forecastEP", (_ep) ->


  get : (spot) ->
    _ep.get "forecast/" + spot



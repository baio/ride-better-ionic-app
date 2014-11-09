app.factory "forecastEP", (_ep) ->


  get : (spot, lang) ->
    _ep.get "forecast/" + spot, lang : lang



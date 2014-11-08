app.factory "reportsEP", (_ep) ->

  get : (spot) ->
    _ep.get "reports/" + spot

  send: (spot, data) ->
    _ep.post "reports/" + spot, data, true


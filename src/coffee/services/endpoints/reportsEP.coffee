app.factory "reportsEP", (_ep) ->

  send: (spot, data) ->
    _ep.post "reports/" + spot, data, true


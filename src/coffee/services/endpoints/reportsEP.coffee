app.factory "reportsEP", (_ep) ->

  send: (spot, data) ->
    _ep.post "reports/" + spot, data, true

  get: (spot, opts) ->
    _ep.get "reports/" + spot, opts

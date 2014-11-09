app.factory "reportsEP", (_ep) ->

  get : (spot, lang) ->
    _ep.get "reports/" + spot, lang : lang

  send: (spot, data) ->
    _ep.post "reports/" + spot, data, true


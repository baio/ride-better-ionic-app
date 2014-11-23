app.factory "talkEP", (_ep) ->

  get: (spot) ->
    _ep.get "spots/" + spot + "/messages"

  send: (spot, data) ->
    _ep.post "spots/" + spot + "/messages", data, true

  remove: (id) ->
    _ep.remove "messages/" + id, true

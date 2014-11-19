app.factory "reportsDA", (reportsEP, homeDA) ->

  send : (spot, data) ->
    reportsEP.send(spot, data).then (res) ->
      homeDA.resetNext()
      res
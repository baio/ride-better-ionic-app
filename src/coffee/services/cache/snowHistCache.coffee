app.factory "snowHistCache", ->

  _latestHist = null

  put: (spot, res) ->
    _latestHist = 
      spot : spot
      res : res

  get: (spot) ->
    if _latestHist?.spot == spot
      _latestHist.res
    else if _latestHist and spot.indexOf("-") == -1
      cached = _latestHist.res.filter((f) -> f.spot == spot)[0]
      console.log "snowHistCache.coffee:15 >>>", cached
      if cached
        [cached]


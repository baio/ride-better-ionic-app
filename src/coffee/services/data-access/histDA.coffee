app.factory "histDA", (histEP, snowHistCache, $q) ->

  getSnowfall : (spot) ->
    cached = snowHistCache.get spot
    if cached 
      return $q.when cached
    histEP.getSnowfall(spot).then (res) ->
      snowHistCache.put spot, res
      res


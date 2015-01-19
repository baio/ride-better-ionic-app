app.factory "histDA", (histEP, snowHistCache, $q) ->

  getSnowfall : (spot, favs) ->
    cached = snowHistCache.get spot
    if cached 
      return $q.when cached
    histEP.getSnowfall(favs).then (res) ->
      snowHistCache.put favs, res
      snowHistCache.get spot


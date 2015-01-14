app.factory "homeDA", (homeEP, homeCache, $q) ->

  get : (opts) ->
    cachedHome = homeCache.get(opts.spot)
    if cachedHome    
      $q.when cachedHome
    else
      homeEP.get(opts).then (res) ->
        homeCache.put opts.spot, res
        res
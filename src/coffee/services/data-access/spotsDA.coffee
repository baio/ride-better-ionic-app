app.factory "spotsDA", ($q, spotsEP, cache) ->

  getCacheName = (spot) -> "spot_" + spot

  get : (spot) ->
    cacheName = getCacheName spot
    cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      spotsEP.get(spot).then (res) ->
        cache.put cacheName, res, 60 * 24 * 2
        res

  find : spotsEP.find
  nearest : spotsEP.nearest
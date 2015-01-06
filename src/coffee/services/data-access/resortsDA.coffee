app.factory "resortsDA", (resortsEP, $q, cache) ->

  getCacheName = (spot) -> "resort_" + spot

  getInfo : (spot) ->    
    cacheName = getCacheName spot
    cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      resortsEP.getInfo(spot).then (res) ->
        cache.put cacheName, res, 60 * 3
        res

  getMaps : resortsEP.getMaps
  getPrices : resortsEP.getPrices
  postPrice : resortsEP.postPrice

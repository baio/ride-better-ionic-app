app.factory "spotsDA", ($q, spotsEP, cache, cultureFormatter, resources) ->

  getCacheName = (spot) -> "spot_" + spot

  formatFind = (spot, cult) ->
    spot.formatted = 
      dist : cultureFormatter.dist spot.dist, cult.units
      distU : resources.str cultureFormatter.distU(cult.units)
    spot 

  get : (spot) ->
    cacheName = getCacheName spot
    cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      spotsEP.get(spot).then (res) ->
        cache.put cacheName, res, 60 * 24 * 2
        res

  find : (term, geo, cult) ->
    spotsEP.find(term, geo).then (res) ->
      res.map (m) -> formatFind(m, cult)

  nearest : spotsEP.nearest
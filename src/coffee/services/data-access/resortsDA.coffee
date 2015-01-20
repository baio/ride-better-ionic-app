app.factory "resortsDA", (resortsEP, $q, cache) ->

  getImg = (img) ->
    thumb : img
    orig : img?.replace(/thumbnail-/, ":original-")

  getCacheName = (spot) -> "resort_" + spot

  mapInfo = (info) ->
    info.headerImg = getImg info.header
    for price in info.prices
      price.img = getImg price.src
    for map in info.maps
      map.img = getImg map.src

    info

  getInfo : (spot) ->    
    cacheName = getCacheName spot
    cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      resortsEP.getInfo(spot).then (res) ->
        res = mapInfo res
        cache.put cacheName, res, 60 * 3
        res

  getMaps : resortsEP.getMaps
  getPrices : resortsEP.getPrices
  postPrice : resortsEP.postPrice
